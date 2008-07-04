# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit cmake-utils eutils flag-o-matic subversion autotools

DESCRIPTION="Great Video editing/encoding tool"
HOMEPAGE="http://fixounet.free.fr/avidemux/"
ESVN_REPO_URI="svn://svn.berlios.de/avidemux/branches/avidemux_2.4_branch"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="amd64 ~ppc x86"
IUSE="+aac aften +alsa amrnb -arts +dts esd -extrafilters +gtk jack +lame
	+libsamplerate +mp3 -qt4 +truetype +vorbis +x264 +xv +xvid"

RDEPEND="dev-libs/libxml2
	>=dev-libs/glib-2
	media-libs/libpng
	media-libs/libsdl
	aac? ( media-libs/faac
		media-libs/faad2 )
	aften? ( media-libs/aften )
	alsa? ( media-libs/alsa-lib )
	amrnb? ( media-libs/amrnb )
	arts? ( kde-base/arts )
	dts? ( media-libs/libdca )
	esd? ( media-sound/esound )
	jack? ( media-sound/jack-audio-connection-kit )
	libsamplerate? ( media-libs/libsamplerate )
	mp3? ( media-libs/libmad )
	lame? ( >=media-sound/lame-3.93 )
	truetype? ( media-libs/freetype
		media-libs/fontconfig )
	vorbis? ( media-libs/libvorbis )
	x264? ( media-libs/x264 )
	xvid? ( media-libs/xvid )
	gtk? ( >=x11-libs/gtk+-2.6
		x11-libs/libX11 )
	qt4? ( || ( >=x11-libs/qt-4.3 x11-libs/qt-gui:4 )
		x11-libs/libX11 )
	xv? ( x11-libs/libXv )"

DEPEND="$RDEPEND
	>=dev-util/cmake-2.4.4
	dev-util/pkgconfig
	sys-devel/gettext"

src_unpack() {
	subversion_src_unpack
	cd "${S}"
	# svn info needs original working copy
	sed -i -e "s:\${PROJECT_SOURCE_DIR}:${ESVN_STORE_DIR}/${ESVN_PROJECT}/${ESVN_REPO_URI##*/}:" cmake/FindSubversion.cmake
	sed -i -e "s:\${dir}:${ESVN_STORE_DIR}/${ESVN_PROJECT}/${ESVN_REPO_URI##*/}:" cmake/FindSubversion.cmake

	epatch "${FILESDIR}"/${PN}_2.4_branch-libdca.patch
	epatch "${FILESDIR}"/${PN}-2.4-i18n.patch

	# gcc-4.3 fixes from Gentoo bug 213099
	#epatch "${FILESDIR}"/${PN}-9999-gcc43-includes.patch
	#epatch "${FILESDIR}"/${PN}-2.4.1-gcc43-missing-asm-naming.patch
}

src_compile() {
	# -O3 seems to corrupt names in the Qt4 filters dialog -yngwin
	use qt4 && replace-flags -O3 -O2

	local mycmakeargs

	# Commented out options cause compilation errors, some
	# might need -Wl,--as-needed in LDFLAGS and all USE
	# flags disabled for reproducing. -drac

	# ConfigureChecks.cmake
	use alsa || mycmakeargs="${mycmakeargs} -DNO_ALSA=1"
	#use oss || mycmakeargs="${mycmakeargs} -DNO_OSS=1"
	#use nls || mycmakeargs="${mycmakeargs} -DNO_NLS=1"
	#use sdl || mycmakeargs="${mycmakeargs} -DNO_SDL=1"

	# ConfigureChecks.cmake -> ADM_CHECK_HL -> cmake/adm_checkHeaderLib.cmake
	use truetype || mycmakeargs="${mycmakeargs} -DNO_FontConfig=1"
	use xv || mycmakeargs="${mycmakeargs} -DNO_Xvideo=1"
	use esd || mycmakeargs="${mycmakeargs} -DNO_Esd=1"
	use jack || mycmakeargs="${mycmakeargs} -DNO_Jack=1"
	use aften || mycmakeargs="${mycmakeargs} -DNO_Aften=1"
	use libsamplerate || mycmakeargs="${mycmakeargs} -DNO_libsamplerate=1"
	use lame || mycmakeargs="${mycmakeargs} -DNO_Lame=1"
	use xvid || mycmakeargs="${mycmakeargs} -DNO_Xvid=1"
	use amrnb || mycmakeargs="${mycmakeargs} -DNO_AMRNB=1"
	use dts || mycmakeargs="${mycmakeargs} -DNO_libdca=1"
	use x264 || mycmakeargs="${mycmakeargs} -DNO_x264=1"
	use aac || mycmakeargs="${mycmakeargs} -DNO_FAAC=1 -DNO_FAAD=1 -DNO_NeAAC=1"
	use vorbis || mycmakeargs="${mycmakeargs} -DNO_Vorbis=1"
	#use png || mycmakeargs="${mycmakeargs} -DNO_libPNG=1"

	# ConfigureChecks.cmake -> cmake/FindArts.cmake
	use arts || mycmakeargs="${mycmakeargs} -DNO_ARTS=1"

	# CMakeLists.txt
	use truetype || mycmakeargs="${mycmakeargs} -DNO_FREETYPE=1"
	use gtk || mycmakeargs="${mycmakeargs} -DNO_GTK=1"
	use qt4 || mycmakeargs="${mycmakeargs} -DNO_QT4=1"

	cmake-utils_src_compile

	if ( use extrafilters ); then
		cd ${S}/avidemux/ADM_filter
		sh buildummy.sh
	fi
}

src_install() {
	cmake-utils_src_install
	dodoc AUTHORS
	doicon avidemux_icon.png
	use gtk && make_desktop_entry avidemux2_gtk "Avidemux GTK" \
		avidemux_icon "AudioVideo;GTK"
	use qt4 && make_desktop_entry avidemux2_qt4 "Avidemux Qt" \
		avidemux_icon "AudioVideo;Qt"

	if use extrafilters; then
		dodir /usr/share/avidemux/
		dodir /usr/share/avidemux/filters
		exeinto /usr/share/avidemux/filters
		doexe ${S}/avidemux/ADM_filter/dummy.so
	fi
}

pkg_postinst() {
	if use extrafilters; then
		echo
		elog "If you want to activate external filters"
		elog "open ~/.avidemux/config file and"
		elog "set filter autoload active to 1"
		elog "set filter autoload path to /usr/share/avidemux/filters"
		elog "You can also set the path in the GUI in the"
		elog "Edit > Preferences > External Filters dialog"
		elog "Note that there are no usable external Avidemux filters yet,"
		elog "so you may find this option useless."
	fi
	if use ppc; then
		echo
		elog "OSS sound output may not work on ppc"
		elog "If your hear only static noise, try"
		elog "changing the sound device to alsa or arts"
	fi
	echo
}
