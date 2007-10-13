# Copyright 1999-2007 Gentoo Foundation 

DESCRIPTION="Replacement for Punto Switcher"
HOMEPAGE="http://www.xneur.ru/" 
SRC_URI="http://dists.xneur.ru/release-${PV}/tgz/${P}.tar.bz2" 

IUSE="spell pcre gstreamer openal"
SLOT="0"

KEYWORDS="x86 amd64" 
DEPEND="x11-libs/libX11
	 pcre? ( dev-libs/libpcre )
	 spell? ( app-text/aspell )"
RDEPEND="${DEPEND}"

src_compile() { 
	local myconf
	myconf="${myconf} `use_with spell aspell`"
	myconf="${myconf} `use_with pcre`"
	myconf="${myconf} `use_with gstreamer`"
	myconf="${myconf} `use_with openal`"
	
	econf --with-x ${myconf} || die "configure failed"
	emake || die "emake failed" 
} 

src_install() { 
	make install DESTDIR=${D} || die "emake install failed" 
}

