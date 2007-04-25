# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/emirror/emirror-2.1.21.ebuild,v 1.6 2006/12/11 08:01:23 beu Exp $

MY_P=${P}-0.4

DESCRIPTION="ECLiPt FTP mirroring tool"
HOMEPAGE="http://eclipt.uni-klu.ac.at/emirror.php"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ~ppc"
IUSE=""

S=${WORKDIR}/${MY_P}

src_compile() {
	./configure \
		--prefix=/usr \
		--sysconfdir=/etc \
		--mandir=/usr/share/man \
	|| die "configure problem"

	emake || die "compile problem"
}

src_install() {
	make \
		prefix=${D}/usr \
		mandir=${D}/usr/share/man/man1 \
		sysconfdir=${D}/etc \
		htmldir=${D}/var/www/mirrors \
	install || die "install problem"
	dodoc doc/*
}
