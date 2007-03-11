# Copyright 1999-2006 Gentoo Foundation 

DESCRIPTION="GUI for xneur based on GTK" 
HOMEPAGE="http://www.xneur.ru/" 
SRC_URI="http://dists.xneur.ru/release-${PV}/tgz/${P}.tar.bz2" 

IUSE=""
SLOT="0"

KEYWORDS="x86 amd64" 
RDEPEND="x11-apps/xneur"
DEPEND="${RDEPEND}"

src_compile() { 
	econf || die "configure failed"
	emake || die "emake failed" 
} 

src_install() { 
	einstall || die "emake install failed" 
}

