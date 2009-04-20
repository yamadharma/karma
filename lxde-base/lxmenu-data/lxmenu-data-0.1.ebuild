# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="LXDE application menu data"
HOMEPAGE="http://lxde.sourceforge.net/"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

RDEPEND=""
DEPEND="sys-devel/gettext
	dev-util/pkgconfig
	>=dev-util/intltool-0.40.0"

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS README
}
