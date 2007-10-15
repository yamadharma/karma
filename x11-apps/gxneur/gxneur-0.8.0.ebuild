# Copyright 1999-2007 Gentoo Foundation 

DESCRIPTION="GUI for xneur based on GTK" 
HOMEPAGE="http://www.xneur.ru/" 
SRC_URI="http://dists.xneur.ru/release-${PV}/tgz/${P}.tar.bz2" 

IUSE="nls"
SLOT="0"

KEYWORDS="x86 amd64" 
RDEPEND="x11-apps/xneur
	 >=x11-libs/gtk+-2.0.0"
DEPEND="${RDEPEND}"

src_compile() { 
	econf $(use_enable nls) || die "configure failed"
	emake || die "emake failed" 
} 

src_install() { 
	make install DESTDIR=${D} || die "emake install failed" 
	make_desktop_entry "${PN}" "${PN}" ${PN}.png "GTK;Gnome;Utility;TrayIcon"
}

