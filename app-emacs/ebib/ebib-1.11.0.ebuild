# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="Visible bookmarks in buffer"
HOMEPAGE="http://ebib.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

LISP_TEXINFO="info/ebib-manual.info"
DOCS="INSTALL README.md doc/ebib-manual.pdf"

