# Copyright 1999-2007 Gleb "Sectoid" Golubitsky
DESCRIPTION="GUI for xneur based on GTK" 

inherit eutils

HOMEPAGE="http://www.xneur.ru/" 

SRC_URI="http://dists.xneur.ru/release-${PV}/tgz/${P}.tar.bz2" 

RESTRICT="mirror"

KEYWORDS="~amd64 x86" 
RDEPEND="=x11-apps/xneur-${PV}
	 >=x11-libs/gtk+-2.0.0"
DEPEND="${RDEPEND}"
SLOT="0"

src_compile() { 
   cd ${WORKDIR}/${P}
#   ./configure --prefix=/usr || die "configure failed"
   econf || die "configure failed"
   emake || die "emake failed" 
} 

src_install() { 
   export INSTALLDIR="/usr"
   emake DESTDIR="${D}" install || die "emake install failed" 
   dosym /usr/share/gxneur/pixmaps/gxneur.png /usr/share/pixmaps/gxneur.png
   make_desktop_entry gxneur gXNeur gxneur Office
}

