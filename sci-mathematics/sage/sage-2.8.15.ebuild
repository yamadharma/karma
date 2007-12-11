# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="number theory and algebraic geometry software"
HOMEPAGE="http://modular.math.washington.edu/sage/"
SRC_URI="http://modular.math.washington.edu/sage/dist/src/${P}.tar"

inherit eutils

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc"
IUSE=""

DEPEND="sys-devel/flex
	dev-lang/perl
	|| (sys-devel/bison dev-util/yacc)"

src_unpack() {
	unpack ${A}
	cd ${S}/spkg/standard
	tar -xf fortran-20071120.p1.spkg
	rm fortran-20071120.p1.spkg
	cd fortran-20071120.p1
	epatch $FILESDIR/sage-2.8.15-fortran-symlink.patch
	cd ..
	tar -cf fortran-20071120.p1.spkg fortran-20071120.p1
	rm -rf fortran-20071120
}

src_compile() {
	emake || die "make failed"
	if ( grep "sage: An error occurred" ${S}/install.log ); then
		die "make failed"
	fi
}

src_install() {
	make DESTDIR="${D}/opt" install
	sed -i "s/SAGE_ROOT=.*\/opt/SAGE_ROOT=\"\/opt/" "${D}/opt/bin/sage" "${D}/opt/sage/sage" 
}
