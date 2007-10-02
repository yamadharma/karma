# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils fetch-tools scons-ccache

DESCRIPTION="multi-track hard disk recording software"
HOMEPAGE="http://ardour.org/"
SRC_URI="http://ardour.org/files/releases/${P}.tar.bz2"
RESTRICT="nomirror"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="x86 amd64"
IUSE="nls debug sse altivec vst sys-libs"

RDEPEND=">=media-libs/liblrdf-0.4.0
	>=media-libs/raptor-1.2.0
	>=media-libs/libart_lgpl-2.3.16
	>=media-libs/ladspa-sdk-1.12
	>=media-libs/libsamplerate-0.0.14
	media-libs/liblo
	>=dev-libs/libxml2-2.5.7
	dev-libs/libxslt
	>=dev-libs/glib-2.10
	>=x11-libs/gtk+-2.6
	>=media-sound/jack-audio-connection-kit-0.100.0
	!=media-sound/ardour2-2*
	vst? ( >=app-emulation/wine-0.9.5 )
	>=gnome-base/libgnomecanvas-2.0
	sys-libs? ( >=dev-libs/libsigc++-2.0
		>=dev-cpp/glibmm-2.4
		>=dev-cpp/cairomm-1.0
		>=dev-cpp/gtkmm-2.8
		>=dev-libs/atk-1.6
		>=x11-libs/pango-1.4 
		>=dev-cpp/libgnomecanvasmm-2.12.0
		>=media-libs/libsndfile-1.0.16
		>=media-libs/libsoundtouch-1.0 )"

	# sys-libs/gdbm # no longer needed?!

DEPEND="${RDEPEND}
	>=dev-libs/boost-1.33.1
	sys-devel/bison
	sys-devel/autoconf
	sys-devel/automake
	>=dev-util/pkgconfig-0.8.0
	>=dev-util/scons-0.96.1
	nls? ( >=sys-devel/gettext-0.12.1 )
	vst? ( app-arch/zip 
		=media-libs/vst-sdk-2.3* )"

pkg_setup(){
	# issue with ACLOCAL_FLAGS if set to a wrong value
	if [ "${#ACLOCAL_FLAGS}" -gt "0" ];then
		ewarn "check your profile settings:"
		ewarn "There is no need to set the ACLOCAL_FLAGS"
		ewarn "environment variable so we unset it"
		unset ACLOCAL_FLAGS
	fi
	if use sys-libs;then
		ewarn "You are trying to use the system libraries"
		ewarn "instead the ones provided by ardour"
		ewarn "No upstream support for doing so. Use at your own risk!!!"
		ewarn "To use the ardour provided libs remerge with:"
		ewarn "USE=\"-sys-libs\" emerge =${P}"
		
		if ! built_with_use dev-cpp/gtkmm accessibility;then
			eerror "To be able to use the USE flag 'sys-libs'"
			eerror "you need to have dev-cpp/gtkmm"
			eerror "emerged with the USE flag 'accessibility'"
			die "dev-cpp/gtkmm is not built with the 'accessibility' USE flag"
		fi
		epause 3s
	fi
}

src_unpack(){
	# abort if user answers no to distribution of vst enabled binaries
	if use vst;then agree_vst || die "you can not distribute ardour with vst support" ;fi
	
	unpack "${P}.tar.bz2"
	cd ${S}
	
	# hack to use the sys-lib for sndlib also
	use sys-libs && epatch "${FILESDIR}/ardour-syslib_mod2.patch"
	
	# change template dir to not overwrite ardour1 stuff
	sed -i -e 's:\(share\)/ardour/\(templates\):\1/ardour2/\2:g' templates/SConscript || die "changing template names failed"
	add_ccache_to_scons
	
	# ################
	# adjust files for vst support
	if use vst;then
		# delete vst question
		touch ${S}/.personal_use_only

		# fix vst header
		sed -ie 's@vstsdk2.3/source/common/aeffectx.h@/usr/include/vst/aeffectx.h@g' libs/fst/SConscript || die "change vst-header location"
		#symlink the include vst include files
		vst_tmp_dir="vstsdk2.3/source/common"
		mkdir -p ${vst_tmp_dir}
		cp -r  /usr/include/vst/./ ${vst_tmp_dir}
		zip -0r  libs/fst/vstsdk2.3.zip vstsdk2.3 &>/dev/null
		#/usr/include/vst/ libs/fst
		#ln -s ${DISTDIR}/vstsdk2.3.zip /libs/fst/
	fi
	# ###############
}

src_compile() {
	# bug 99664
#	cd ${S}/libs/glibmm2
	#chmod a+x autogen.sh && ./autogen.sh || die "autogen failed"
	#cd ${S}/libs/sigc++2/
	#chmod a+x autogen.sh && ./autogen.sh || die "autogen failed"
#	econf || die "configure failed"
	
	# Required for scons to "see" intermediate install location
	mkdir -p ${D}
	
	local myconf=""
	! use altivec; myconf="${myconf} ALTIVEC=$?"
	! use debug; myconf="${myconf} ARDOUR_DEBUG=$?"
	! use nls; myconf="${myconf} NLS=$?" 
	! use vst; myconf="${myconf} VST=$?" 
	! use sys-libs; myconf="${myconf} SYSLIBS=$?"
	! use sse; myconf="${myconf} USE_SSE_EVERYWHERE=$? BUILD_SSE_OPTIMIZATIONS=$?"
	# static settings
	myconf="${myconf} PREFIX=/usr KSI=0" # NLS=0"
	einfo "${myconf}"

	cd ${S}
	scons ${myconf}	|| die "compilation failed"
}

src_install() {
	scons DESTDIR="${D}" install || die "make install failed"
	if use vst;then
		newbin vst/ardour_vst.exe.so ardour2.exe.so
		newbin vst/ardour_vst ardour2
		fperms 644 /usr/bin/ardour2.exe.so
		sed -i -e'/^appname/'i"export\ LD_LIBRARY_PATH=\"/usr/lib/ardour2/:\$LD_LIBRARY_PATH\"" ${D}/usr/bin/ardour2

		# fix ardour file_name
		sed -i -e 's@ardour_vst@ardour2@' ${D}/usr/bin/ardour2
	else
		# fix ardour path
		sed -i -e 's:'${D}'::g' ${D}/usr/bin/ardour2
	fi

	cd DOCUMENTATION/
	for i in `find -iname 'CVS'`;do rm -rf ${i};done
	cd - &>/dev/null
	dodoc  DOCUMENTATION/*
}

agree_vst() {
	local ANSWER="no"
	einfo "Are you building Ardour for personal use (rather than distribution to others)? [yes/no]: "
	read ANSWER
	if [ "$ANSWER" == "y" ] || [ "$ANSWER" == "yes" ];then
		einfo "OK, VST support will be enabled"
		# delete question from SConscript
		#sed -i -e '/Make\ sure\ they/,/print\ \"OK,\ VST\ support\ will\ be\ enabled\"/d' "${S}"/SConstruct || die " failed to del vst question"
	else
		eerror "You cannot build Ardour with VST support for distribution to others"
		eerror "It is a violation of several different licenses"
	
		eerror "use: USE=-vst emerge $P"
		eerror "to disable vst support"
		return 1
	fi
}
