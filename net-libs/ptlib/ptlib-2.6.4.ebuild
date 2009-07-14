# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild come from voip overlay, with small modification by Ycarus for Zugaina overlay.

EAPI="2"

inherit eutils flag-o-matic

DESCRIPTION="Network focused portable C++ class library providing high level functions"
HOMEPAGE="http://www.opalvoip.org/"
SRC_URI="mirror://sourceforge/opalvoip/${P}.tar.bz2
	doc? ( mirror://sourceforge/opalvoip/${P}-htmldoc.tar.bz2 )"

LICENSE="MPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
# default enabled are features from 'minsize', the most used according to ptlib
IUSE="alsa +asn +audio config-file debug dns doc dtmf esd examples ffmpeg ftp
+http http-forms http-server ieee1394 ipv6 jabber ldap mail odbc oss pch
pipechan qos remote sasl sdl serial shmvideo snmp soap socks ssl +stun telnet
tts +url v4l v4l2 +video vxml wav xml xmlrpc"

COMMON_DEP="audio? ( alsa? ( media-libs/alsa-lib )
		esd? ( media-sound/esound ) )
	ldap? ( net-nds/openldap )
	odbc? ( dev-db/unixODBC )
	sasl? ( dev-libs/cyrus-sasl:2 )
	sdl? ( media-libs/libsdl )
	ssl? ( dev-libs/openssl )
	video? ( ieee1394? ( media-libs/libdv
			sys-libs/libavc1394
			media-libs/libdc1394:1 )
		v4l2? ( media-libs/libv4l ) )
	xml? ( dev-libs/expat )"
RDEPEND="${COMMON_DEP}
	ffmpeg? ( media-video/ffmpeg )"
DEPEND="${COMMON_DEP}
	dev-util/pkgconfig
	sys-devel/bison
	sys-devel/flex
	video? ( v4l? ( sys-kernel/linux-headers )
		v4l2? ( sys-kernel/linux-headers ) )
	!!dev-libs/pwlib"

# NOTES:
# media-libs/libdc1394:2 should be supported but headers location have changed
# tools/ directory is ignored
# looks to have an auto-magic dep with medialibs, but not in the tree so...
# 	TODO: contact upstream about this auto-magic dep
# TODO: according to scanelf, there is a dep with libraw1394

pkg_setup() {
	local warning=false

	# ekiga can't use, at least, alsa plugin with --as-needed
	# users where experiencing issues with --as-needed, see bug 238617
	# TODO: should be re-tested and, if possible, fixed in a cleanier way
	append-ldflags -Wl,--no-as-needed

	# bug that make ptlib unusable when ffmpeg is enabled without pipechan
	# upstream has been contacted, see bug 2726070
	if use ffmpeg && ! use pipechan; then
		eerror "ffmpeg can't be enabled without enabling pipechan"
		eerror "Please, try again with disabling ffmpeg or enabling pipechan"
		die
	fi

	# warn user about use flag that are gonna override other ones

	if ! use audio; then
		ewarn "disabling audio will remove all audio support"
		ewarn "even if other audio features have been enabled"
		warning=true
	fi

	if ! use video; then
		ewarn "disabling video will remove all video support"
		ewarn "even if other video features have been enabled"
		warning=true
	fi

	if use jabber && ! use xml; then
		ewarn "jabber support needs xml support: jabber has been disabled"
		ewarn "enable xml support if you want to use the jabber protocol"
		warning=true
	fi

	if use http && ! use url; then
		ewarn "http support needs url support: http support has been disabled"
		ewarn "enable url support if you want to use the http protocol"
		warning=true
	fi

	if use http-forms; then
		if ! use http; then
			ewarn "http-forms support needs http support: http-forms support has been disabled"
			ewarn "enable http support if you want to use http-forms"
			warning=true
		fi
		if ! use config-file; then
			ewarn "http-forms support needs config-file support: http-forms support has been disabled"
			ewarn "enable config-file support if you want to use http-forms"
			warning=true
		fi
	fi

	if use http-server && ! use http-forms; then
		ewarn "http-server support needs http-forms support: http-server support has been disabled"
		ewarn "enable http-forms support if you want to use http-server"
		warning=true
	fi

	if use vxml; then
		if ! use xml; then
			ewarn "vxml support needs xml support: vxml support has been disabled"
			ewarn "enable xml support if you want to use vxml"
			warning=true
		fi
		if ! use http; then
			ewarn "vxml support needs http support: vxml support has been disabled"
			ewarn "enable http support if you want to use vxml"
			warning=true
		fi
	fi

	if use xmlrpc; then
		if ! use xml; then
			ewarn "xmlrpc support needs xml support: xmlrpc support has been disabled"
			ewarn "enable xml support if you want to use xmlrpc"
			warning=true
		fi
		if ! use http; then
			ewarn "xmlrpc support needs http support: xmlrpc support has been disabled"
			ewarn "enable http support if you want to use xmlrpc"
			warning=true
		fi
	fi

	if use soap; then
		if ! use xml; then
			ewarn "soap support needs xml support: soap support has been disabled"
			ewarn "enable xml support if you want to use soap"
			warning=true
		fi
		if ! use http; then
			ewarn "soap support needs http support: soap support has been disabled"
			ewarn "enable http support if you want to use soap"
			warning=true
		fi
	fi

	if ${warning}; then
		echo
		ewarn "If one of the warnings above is not volunteer, hit Ctrl+C now"
		ewarn "and re-emerge ${PN} with the desired USE flags"
		echo
		ebeep
		epause
	fi
}

src_prepare() {
	# move files from ${P}-htmldoc.tar.gz
	if use doc; then
		mv ../html . || die "moving doc files failed"
	fi

	# remove visual studio related files from samples/
	if use examples; then
		rm -f samples/*/*.vcproj
		rm -f samples/*/*.sln
		rm -f samples/*/*.dsp
		rm -f samples/*/*.dsw
	fi

	# --enable-ansi-bool and --disable-ansi-bool are the same
	# we want to enable it so to prevent eautoreconf, a sed script is enough
	# upstream has been contacted with a patch, see bug 2685609 in patch tracker
	# TODO: has been accepted by upstream, check for fix when bumping
	sed -i -e "s/\${enable_ansi_bool}x/x/" configure \
		|| die "patching configure failed"
}

src_configure() {
	local myconf=""

	# plugins are disabled only if ! audio and ! video
	if ! use audio && ! use video; then
		myconf="${myconf} --disable-plugins"
	else
		myconf="${myconf} --enable-plugins"
	fi

	# minsize, openh323, opal: presets of features (overwritten by use flags)
	# ansi-bool, atomicity: there is no reason to disable those features
	# internalregex: we want to use system one
	# sunaudio and bsdvideo are respectively for SunOS and BSD's
	# appshare, vfw: only for windows
	# sockagg: always enabled, see bug 2685379 in upstream bugtracker
	# samples: no need to build samples
	# vidfile has been merged with video use flag
	econf ${myconf} \
		--disable-minsize \
		--disable-openh323 \
		--disable-opal \
		--enable-ansi-bool \
		--enable-atomicity \
		--disable-internalregex \
		--disable-sunaudio \
		--disable-bsdvideo \
		--disable-appshare \
		--disable-vfw \
		--enable-sockagg \
		--disable-samples \
		$(use_enable audio) \
		$(use_enable alsa) \
		$(use_enable asn) \
		$(use_enable config-file configfile) \
		$(use_enable debug exceptions) \
		$(use_enable debug memcheck) \
		$(use_enable debug tracing) \
		$(use_enable dtmf) \
		$(use_enable esd) \
		$(use_enable ffmpeg ffvdev) \
		$(use_enable ftp) \
		$(use_enable http) \
		$(use_enable http-forms httpforms) \
		$(use_enable http-server httpsvc) \
		$(use_enable ieee1394 avc) \
		$(use_enable ieee1394 dc) \
		$(use_enable ipv6) \
		$(use_enable jabber) \
		$(use_enable ldap openldap) \
		$(use_enable mail pop3smtp) \
		$(use_enable odbc) \
		$(use_enable oss) \
		$(use_enable pch) \
		$(use_enable pipechan) \
		$(use_enable qos) \
		$(use_enable remote remconn) \
		$(use_enable dns resolver) \
		$(use_enable sasl) \
		$(use_enable sdl) \
		$(use_enable serial) \
		$(use_enable shmvideo) \
		$(use_enable snmp) \
		$(use_enable soap) \
		$(use_enable socks) \
		$(use_enable ssl openssl) \
		$(use_enable stun) \
		$(use_enable telnet) \
		$(use_enable tts) \
		$(use_enable url) \
		$(use_enable v4l) \
		$(use_enable v4l2) \
		$(use_enable video) \
		$(use_enable video vidfile) \
		$(use_enable vxml) \
		$(use_enable wav wavfile) \
		$(use_enable xml expat) \
		$(use_enable xmlrpc)
}

src_compile() {
	local makeopts=""

	use debug && makeopts="debug"

	emake ${makeopts} || die "emake failed"
}

src_install() {
	local makeopts=""

	use debug && makeopts="DEBUG=1"

	emake DESTDIR="${D}" ${makeopts} install || die "emake install failed"

	if use doc; then
		dohtml -r html/* || die "dohtml failed"
	fi

	dodoc History.txt ReadMe.txt ReadMe_QOS.txt || die "dodoc failed"

	# ChangeLog is not standard
	dodoc ChangeLog-${PN}-v${PV//./_}.txt || die "dodoc failed"

	if use examples; then
		local exampledir="/usr/share/doc/${PF}/examples"
		local basedir="samples"
		local sampledirs="`ls samples --hide=Makefile`"

		# first, install Makefile
		insinto ${exampledir}/
		doins ${basedir}/Makefile || die "doins failed"

		# now, all examples
		for x in ${sampledirs}; do
			insinto ${exampledir}/${x}/
			doins ${basedir}/${x}/* || die "doins failed"
		done
	fi
}

pkg_postinst() {
	if use examples; then
		ewarn "All examples have been installed, some of them will not work on your system"
		ewarn "it will depend of the enabled USE flags."
		ewarn "To test examples, you have to run PTLIBDIR=/usr/share/ptlib make"
	fi
}

