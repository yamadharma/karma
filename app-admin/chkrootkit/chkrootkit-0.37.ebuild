# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/app-admin/chkrootkit/chkrootkit-0.37.ebuild,v 1.12 2003/09/20 19:56:29 aliz Exp $

DESCRIPTION="a tool to locally check for signs of a rootkit"
SRC_URI="ftp://ftp.pangeia.com.br/pub/seg/pac/${P}.tar.gz"
HOMEPAGE="http://www.chkrootkit.org/"

KEYWORDS="x86 ppc sparc alpha"
LICENSE="AMS"
SLOT="0"

DEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PF}-gentoo.diff
}

src_compile() {
	make sense || die
}

src_install() {
	dosbin check_wtmpx chklastlog chkproc chkrootkit chkwtmp ifpromisc
	dodoc COPYRIGHT README README.chklastlog README.chkwtmp
}
