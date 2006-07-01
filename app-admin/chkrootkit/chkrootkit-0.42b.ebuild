# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/app-admin/chkrootkit/chkrootkit-0.42b.ebuild,v 1.4 2003/11/24 10:16:58 seemant Exp $

inherit eutils

DESCRIPTION="a tool to locally check for signs of a rootkit"
SRC_URI="ftp://ftp.pangeia.com.br/pub/seg/pac/${P}.tar.gz"
HOMEPAGE="http://www.chkrootkit.org/"
IUSE=""
KEYWORDS="x86 ~ppc ~sparc alpha ~ia64"
LICENSE="AMS"
SLOT="0"

DEPEND="virtual/glibc"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/${P}-gentoo.diff

	sed -i 's:${head} -:${head} -n :' chkrootkit
}

src_compile() {
	make sense || die
	make strings || die
}

src_install() {
	into /usr
	dosbin check_wtmpx chklastlog chkproc chkrootkit chkwtmp ifpromisc
	newsbin strings strings-static
	dodoc COPYRIGHT README README.chklastlog README.chkwtmp
}
