# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit latex-package font

MY_P=cm-unicode-${PV}

DESCRIPTION="Computer Modern Unicode fonts"
HOMEPAGE="http://canopus.iacp.dvo.ru/~panov/cm-unicode/"
SRC_URI="mirror://sourceforge/cm-unicode/${MY_P}-ttf.tar.xz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

FONT_BUNDLE=cm-unicode

S=${WORKDIR}/${MY_P}

FONT_SUFFIX="ttf"

DOCS="README Changes FAQ TODO Fontmap* INSTALL"

src_unpack() {
	tar -xJvf ${DISTDIR}/${MY_P}-ttf.tar.xz
}