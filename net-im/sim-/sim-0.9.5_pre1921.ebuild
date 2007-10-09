# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde-functions eutils flag-o-matic subversion

ESVN_OPTIONS="-r${PV/*_pre}"
# ESVN_STORE_DIR="${PORTAGE_ACTUAL_DISTDIR-${DISTDIR}}/svn-src/berlios.de/sim-im"

ESVN_REPO_URI="http://svn.berlios.de/svnroot/repos/sim-im/trunk"	    

DESCRIPTION="Simple Instant Messenger (with KDE support). ICQ/AIM/Jabber/MSN/Yahoo."
HOMEPAGE="http://sim-im.org/"
#SRC_URI="http://download.berlios.de/sim-im/${P}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="debug kde spell ssl"

BUILDDIR="${WORKDIR}/build"

# kdebase-data provides the icon "licq.png"
RDEPEND="kde? ( kde-base/kdelibs
				|| ( kde-base/kdebase-data kde-base/kdebase ) )
		 !kde? ( $(qt_min_version 3)
				 spell? ( app-text/aspell ) )
		 ssl? ( dev-libs/openssl )
		 dev-libs/libxml2
		 dev-libs/libxslt
		 sys-libs/zlib
		 || ( x11-libs/libXScrnSaver virtual/x11 )"

DEPEND="${RDEPEND}
	sys-devel/flex
	app-arch/zip
	|| ( x11-proto/scrnsaverproto virtual/x11 )
	>=sys-devel/libtool-1.5.22
	>=dev-util/cmake-2.4.4"

pkg_setup() {
	if use kde ; then
		if use spell; then
			if ! built_with_use kde-base/kdelibs spell ; then
				ewarn "kde-base/kdelibs were merged without spell in USE."
				ewarn "Thus spelling will not work in sim. Please, either"
				ewarn "reemerge kde-base/kdelibs with spell in USE or emerge"
				ewarn 'sim with USE="-spell" to avoid this message.'
				ebeep
			fi
		else
			if built_with_use kde-base/kdelibs spell ; then
				ewarn 'kde-base/kdelibs were merged with spell in USE.'
				ewarn 'Thus spelling will work in sim. Please, either'
				ewarn 'reemerge kde-base/kdelibs without spell in USE or emerge'
				ewarn 'sim with USE="spell" to avoid this message.'
				ebeep
			fi
		fi
		if ! built_with_use kde-base/kdelibs arts ; then
			myconf="--without-arts"
		fi
	fi
}

src_compile() {
	local CMAKE_VARIABLES=""

	mkdir "${BUILDDIR}" || die "Failed to generate build directory"

	filter-flags -fstack-protector -fstack-protector-all

	# Workaround for bug #119906
	append-flags -fno-stack-protector

#        export WANT_AUTOCONF=2.5
#	export WANT_AUTOMAKE=1.7

	if use kde  
	    then
	    set-kdedir 3
	    CMAKE_VARIABLES="${CMAKE_VARIABLES} -DUSE_KDE3=YES"
	fi

#	set-kdedir 3
	addwrite "${QTDIR}/etc/settings"


#	CMAKE_VARIABLES="${CMAKE_VARIABLES} -DPV_INSTALL_LIB_DIR:PATH=/${PVLIBDIR}"
#	CMAKE_VARIABLES="${CMAKE_VARIABLES} -DCMAKE_SKIP_RPATH:BOOL=YES"
#	CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_RPATH:BOOL=NO"
	CMAKE_VARIABLES="${CMAKE_VARIABLES} -DCMAKE_INSTALL_PREFIX:PATH=/usr"
#	CMAKE_VARIABLES="${CMAKE_VARIABLES} -DBUILD_SHARED_LIBS:BOOL=ON"
#	CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_SYSTEM_FREETYPE:BOOL=ON"
#	CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_SYSTEM_JPEG:BOOL=ON"
#	CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_SYSTEM_PNG:BOOL=ON"
#	CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_SYSTEM_TIFF:BOOL=ON"
#	CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_SYSTEM_ZLIB:BOOL=ON"
#	CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_SYSTEM_EXPAT:BOOL=ON"

#	make -f admin/Makefile.common

#	use kde || use spell || export DO_NOT_COMPILE="$DO_NOT_COMPILE plugins/spell"

	cd "${BUILDDIR}"

#	econf ${myconf} `use_enable kde` \
#		  `use_with ssl` \
#		  `use_enable debug` || die "econf failed"

	cmake ${CMAKE_VARIABLES} ${S} \
		|| die "cmake configuration failed"

	emake -j1 || die "make failed"
}

src_install() {
	cd "${BUILDDIR}"
	make DESTDIR="${D}" install || die "make install failed."
	cd ${S}
	dodoc TODO* README* AUTHORS.sim jisp-resources.txt ChangeLog*
}
