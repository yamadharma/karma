# Copyright 1999-2007 Gentoo Foundation 

DESCRIPTION="Replacement for Punto Switcher"
HOMEPAGE="http://www.xneur.ru/" 
SRC_URI="http://dists.xneur.ru/release-${PV}/tgz/${P}.tar.bz2" 

IUSE=""
SLOT="0"

KEYWORDS="x86 amd64" 
DEPEND="x11-libs/libX11
	 dev-libs/libpcre"
RDEPEND="${DEPEND}"

src_compile() { 
	econf || die "configure failed"
	emake || die "emake failed" 
} 

src_install() { 
	make install DESTDIR=${D} || die "emake install failed" 
}

