# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="GStreamer plugin for the PulseAudio sound server"
HOMEPAGE="http://0pointer.de/lennart/projects/gst-pulse/"
SRC_URI="http://0pointer.de/lennart/projects/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ~ppc"
IUSE=""

RDEPEND=">=media-sound/pulseaudio-${PV}
	>=media-libs/gstreamer-0.10"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
	econf --disable-lynx || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dohtml -r doc
	dodoc README
}
