# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit latex-package font

MY_P=cm-unicode-${PV}

DESCRIPTION="Computer Modern Unicode fonts"
HOMEPAGE="http://canopus.iacp.dvo.ru/~panov/cm-unicode/"
SRC_URI="mirror://sourceforge/cm-unicode/${MY_P}-otf.tar.gz"

LICENSE="X11"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

FONT_BUNDLE=cm-unicode

S=${WORKDIR}/${MY_P}

FONT_SUFFIX="otf"

DOCS="README Changes FAQ TODO Fontmap* INSTALL"

