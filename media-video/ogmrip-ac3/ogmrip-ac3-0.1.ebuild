# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="This ogmrip plugin provides support for the Mpeg-1 and Mpeg-2 video codecs and the Mpeg container"
HOMEPAGE="http://ogmrip.sourceforge.net/"
SRC_URI="mirror://sourceforge/ogmrip/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""
KEYWORDS="amd64 ~ppc ~ppc64 x86"

DEPEND=">=media-video/ogmrip-0.12
	media-video/mplayer
	media-libs/aften"

RDEPEND="${DEPEND}"

src_install() {
	make install DESTDIR=${D}
	dodoc AUTHORS ChangeLog README NEWS TODO
}