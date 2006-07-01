# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Rebuild packages that compile/install kernel modules"
HOMEPAGE="http://varnerfamily.org/pvarner/gentoo"
SRC_URI="http://varnerfamily.org/pvarner/gentoo/${P}.tar.gz"
RESTRICT="nomirror"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc ~alpha ~mips ~hppa ~arm ~amd64 ~ia64"
IUSE=""
DEPEND=">=app-portage/gentoolkit-0.1.36"
RDEPEND=$DEPEND
S=${WORKDIR}/${P}

src_install() {
	dobin kernelmod-rebuild
	doman kernelmod-rebuild.1
	insinto /etc
	doins ${FILESDIR}/kernelmod-rebuild.conf
}
