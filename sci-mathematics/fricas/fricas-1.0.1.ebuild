# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/axiom/axiom-3.9-r1.ebuild,v 1.5 2007/07/22 06:57:09 dberkholz Exp $

inherit eutils multilib elisp-common latex-package

MY_P=${P}-full

DESCRIPTION="FriCAS Project FriCAS is a fork of Axiom"
HOMEPAGE="http://www.math.uni.wroc.pl/~hebisch/fricas.html
	http://fricas.sf.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="X"
# IUSE="clisp sbcl gcl"

# FIXME. Don't compile with dev-lisp/gcl. See bug# 183544.

DEPEND="dev-lisp/sbcl
	app-text/noweb
	x11-libs/libXaw"
	
#||( dev-lisp/gcl
#	dev-lisp/sbcl 
#	dev-lisp/clisp 
#	dev-lisp/ecls )	

RDEPEND="${DEPEND}
	virtual/latex-base
	"	

S="${WORKDIR}/${MY_P}"

src_compile() {
	local myconf
	
	myconf="${myconf} --with-lisp=sbcl"
	myconf="${myconf} $(use_with X x)"
		
	econf \
	    ${myconf} || die
	make || die # -jX breaks ?
}

src_install() {
	einstall || die

	sed -e "s:${D}:/:g" -i ${D}/usr/bin/axiom || die 'Failed to patch axiom runscript!'
	sed -e "s:axiom/target:fricas/target:g" -i ${D}/usr/bin/axiom || die 'Failed to patch axiom runscript!'
	mv ${D}/usr/bin/axiom ${D}/usr/bin/${PN}

	elisp-install axiom ${S}/contrib/emacs/*.el
	
	insinto ${TEXMF}/tex/latex/axiom
	doins ${S}/src/scripts/tex/axiom.sty
	
	mv ${D}/usr/$(get_libdir)/axiom ${D}/usr/$(get_libdir)/fricas
}
