# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Field-theory motivated computer algebra system"
HOMEPAGE="http://www.aei.mpg.de/~peekas/cadabra"
SRC_URI="http://www.aei.mpg.de/~peekas/cadabra/${P}.tar.gz"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc examples X"
DEPEND="sci-libs/modglue
	sci-mathematics/lie
	dev-libs/gmp
	dev-libs/libpcre
	doc? ( virtual/tetex )
	X? ( >=x11-libs/gtk+-2.0
	    >=dev-cpp/gtkmm-2.4
	    app-text/dvipng )"
RDEPEND="${DEPEND}
	|| ( app-text/texlive dev-tex/breqn )"

src_compile() {
	econf || die
	emake || die

	if ( use doc )
	then
		cd ${S}/doc
		make
		cd doxygen/latex
		make pdf
	fi
}

src_install() {
	einstall DESTDIR=${D} DEVDESTDIR=${D} || die

	dodoc AUTHORS COPYING ChangeLog INSTALL
#	use doc && dohtml ${S}/doc/*
	use examples &&	cp -R ${S}/examples ${D}/usr/share/doc/${PF}

	if ( use doc )	
		then
		cd ${S}/doc/doxygen
		dohtml html/*
		cp latex/*.pdf ${D}/usr/share/doc/${PF}
	fi
	
	rm -rf ${D}/usr/share/TeXmacs

}
