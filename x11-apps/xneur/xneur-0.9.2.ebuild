# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="In-place conversion of text typed in with a wrong keyboard layout (Punto Switcher replacement)"
HOMEPAGE="http://www.xneur.ru/"
if [[ "${PV}" =~ (_p)([0-9]+) ]] ; then
	inherit subversion autotools
	SRC_URI=""
	MTSLPT_REV=${BASH_REMATCH[2]}
	ESVN_REPO_URI="svn://xneur.ru:3690/xneur/${PN}/@${MTSLPT_REV}"
else
	inherit eutils autotools
	SRC_URI="http://dists.xneur.ru/release-${PV}/tgz/${P}.tar.bz2"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="spell pcre gstreamer openal aplay xpm debug"

# Sound does not works here with media-sound/alsa-utils-1.0.16
RDEPEND=">=x11-libs/libX11-1.1
	x11-libs/libXtst
	xpm? ( x11-libs/libXpm )
	gstreamer? ( >=media-libs/gstreamer-0.10.6 )
	!gstreamer? ( openal? ( >=media-libs/freealut-1.0.1 )
				  !openal? ( aplay? ( >=media-sound/alsa-utils-1.0.17 ) ) )
	pcre? ( >=dev-libs/libpcre-5.0 )
	spell? ( app-text/aspell )"
DEPEND="${RDEPEND}
	gstreamer? ( media-libs/gst-plugins-good
				media-plugins/gst-plugins-alsa )
		>=dev-util/pkgconfig-0.20"

src_unpack() {
	if [[ ${SRC_URI} == "" ]]; then
		subversion_src_unpack
	else
		unpack ${A}
	fi
	cd "${S}"

	epatch "${FILESDIR}/${P}-CFLAGS.patch"
	sed -i -e "s/-Werror -g0//" configure.in
	eautoreconf
}

src_compile() {
	local myconf
	if use gstreamer; then
		elog "Using gstreamer for sound output."
		myconf="--with-sound=gstreamer"
	elif use openal; then
		elog "Using openal for sound output."
		myconf="--with-sound=openal"
	elif use aplay; then
		elog "Using aplay for sound output."
		myconf="--with-sound=aplay"
	else
		myconf="--with-sound=no"
	fi

	econf ${myconf} \
		$(use_with spell aspell) \
		$(use_with debug) \
		$(use_with xpm) \
		$(use_with pcre)

	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc AUTHORS ChangeLog README NEWS TODO
}

pkg_postinst() {
	elog "This is command line tool. If you are looking for GUI frontend take a"
	elog "look at kxneur (best for kde users) or gxneur (best for gnome/gtk+"
	elog "users) tools, which use xneur transparently as backend."
}
