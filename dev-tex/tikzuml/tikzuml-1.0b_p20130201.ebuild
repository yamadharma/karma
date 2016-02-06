# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit latex-package

DESCRIPTION="TikZ extension to manage common UML diagrams"
HOMEPAGE="http://perso.ensta-paristech.fr/~kielbasi/tikzuml/"
MY_P=${PN}-v${PV/_p*/}
SRC_URI="http://perso.ensta-paristech.fr/~kielbasi/${PN}/src/${MY_P}-${PV: -8:4}-${PV: -4:2}-${PV: -2:2}.tbz"

LICENSE="tba"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc examples"

S=${WORKDIR}/${MY_P}

src_install() {
	latex-package_src_install
	if use doc; then
		cd "${S}/doc"  || die
		latex-package_src_install
	fi
	if use examples; then
		cd "${S}/examples"  || die
		latex-package_src_install
	fi
}
