# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="This ogmrip plugin should be used to extract a title from a DVD without any encoding"
HOMEPAGE="http://ogmrip.sourceforge.net/"
SRC_URI="mirror://sourceforge/ogmrip/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""
KEYWORDS="amd64 ~ppc ~ppc64 x86"

DEPEND=">=media-video/ogmrip-0.12
	media-video/mplayer"

RDEPEND="${DEPEND}"

src_install() {
	make install DESTDIR=${D}
	dodoc AUTHORS ChangeLog README NEWS TODO
}