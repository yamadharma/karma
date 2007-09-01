# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs

MY_V4L2_PATCH_V="2.1.1"

DESCRIPTION="Wengophone NG is a VoIP client featuring the SIP protcol"
HOMEPAGE="http://dev.openwengo.com"
SRC_URI="http://download.wengo.com/nightlybuilds/universal/sources/openwengo/${PV}/${P}-source.zip http://nguyenchithanh.googlepages.com/${PN}-${MY_V4L2_PATCH_V}-v4l2-patches.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="alsa debug oss portaudio v4l2 xv"

RDEPEND=">=dev-libs/boost-1.34
	dev-libs/glib
	dev-libs/openssl
	alsa? ( media-libs/alsa-lib )
	media-libs/libsamplerate
	media-libs/libsndfile
	media-video/ffmpeg
	net-libs/gnutls
	|| ( x11-libs/libX11 virtual/x11 )
	>=x11-libs/qt-4.1
	xv? ( x11-libs/libXv )"

DEPEND="${RDEPEND}
	>=dev-util/cmake-2.4.4"

S=${WORKDIR}/${P}-source

src_unpack() {
	unpack ${A}
	cd ${S} || die

	epatch ${FILESDIR}/phapi_newerffmpeg.diff
	epatch ${FILESDIR}/pixertool_newerffmpeg.diff
	epatch ${FILESDIR}/wengophone_externavcodec.diff

	if use v4l2; then
		cd ${S}/libs/owpixertool || die
		epatch ${WORKDIR}/owpixertool-v4l2.patch
		cd ${S}/libs/owwebcam || die
		epatch ${WORKDIR}/owwebcam-v4l2.patch
	fi
}
src_compile() {

	local mycmakeflags

	if ! has_version '>=net-misc/curl-7.16.1'; then
		elog "curl 7.16.1 or later not installed, using internal curl"
		mycmakeflags="${mycmakeflags} -DCURL_INTERNAL=ON"
	fi

	if ! has_version '>=net-libs/libosip-3.0.1'; then
		elog "libosip 3.0.1 or later not installed, using internal libosip"
		mycmakeflags="${mycmakeflags} -DOSIP2_INTERNAL=ON"
	fi

	if ! has_version '>=media-libs/speex-1.1.12'; then
		elog "speex 1.1.12 or later not installed, using internal speex"
		mycmakeflags="${mycmakeflags} -DSPEEX_INTERNAL=ON"
	fi

	if use debug; then
		mycmakeflags="${mycmakeflags} -DCMAKE_BUILD_TYPE=Debug"
	else
		mycmakeflags="${mycmakeflags} -DCMAKE_BUILD_TYPE=Release"
	fi

	if use portaudio; then
		mycmakeflags="${mycmakeflags} -DOWSOUND_PORTAUDIO_SUPPORT=ON"
	else
		mycmakeflags="${mycmakeflags} -DOWSOUND_PORTAUDIO_SUPPORT=OFF"
	fi

	if use alsa; then
		mycmakeflags="${mycmakeflags} -DPHAPI_AUDIO_ALSA_SUPPORT=ON \
			-DPORTAUDIO_ALSA_SUPPORT=ON"
	else
		mycmakeflags="${mycmakeflags} -DPHAPI_AUDIO_ALSA_SUPPORT=OFF \
			-DPORTAUDIO_ALSA_SUPPORT=OFF"
	fi

	if use oss; then
		mycmakeflags="${mycmakeflags} -DPHAPI_AUDIO_OSS_SUPPORT=ON \
			-DPORTAUDIO_OSS_SUPPORT=ON"
	else
		mycmakeflags="${mycmakeflags} -DPHAPI_AUDIO_OSS_SUPPORT=OFF \
			-DPORTAUDIO_OSS_SUPPORT=OFF"
	fi

	if use xv; then
		mycmakeflags="${mycmakeflags} -DWENGOPHONE_XV_SUPPORT=ON"
	else
		mycmakeflags="${mycmakeflags} -DWENGOPHONE_XV_SUPPORT=OFF"
	fi

	cd ${S}/build
	cmake -DCMAKE_INSTALL_PREFIX="/usr" ${mycmakeflags} \
		.. || die "cmake failed"
	emake || die "make failed"
}

src_install() {
	cd ${S}/build
	emake DESTDIR=${D} install || die "install failed"
	domenu ../wengophone/res/wengophone.desktop
	doicon ../wengophone/res/wengophone_64x64.png
}

pkg_postinst() {
	elog 'execute "qtwengophone" to start wengophone'
}
