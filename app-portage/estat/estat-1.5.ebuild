# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Emerge progress monitor"
HOMEPAGE="http://www.hotspringsmt.net/rickest/estat/"
SRC_URI="http://www.hotspringsmt.net/rickest/estat/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="app-portage/genlop
	dev-perl/TermReadKey"
RDEPEND=""

src_install()
{
	mkdir -p "${D}"/usr/bin
	cp estat "${D}"/usr/bin
	chmod +x "${D}"/usr/bin/estat

	mkdir -p "${D}"/usr/share/man/man1
	cp estat.1.bz2 "${D}"/usr/share/man/man1
}
