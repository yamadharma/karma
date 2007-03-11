# Copyright 1999-2006 Gentoo Foundation 

DESCRIPTION="It's program like Punto Switcher" 
HOMEPAGE="http://www.xneur.ru/" 
SRC_URI="http://dists.xneur.ru/release-0.4.0/tgz/${P}.tar.bz2" 

IUSE=""
SLOT="0"

KEYWORDS="x86 amd64" 
RDEPEND="x11-base/xorg-x11"
DEPEND="${RDEPEND}"

src_compile() { 
	econf || die "configure failed"
	emake || die "emake failed" 
} 

src_install() { 
	einstall || die "emake install failed" 
}

