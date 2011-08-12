# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit distutils

DESCRIPTION="Creates djvu files with positional ocr, metadata, and bookmarks."
SRC_URI="http://djvubind.googlecode.com/files/${PN}-${PV}.tar.bz2"
HOMEPAGE="http://code.google.com/p/${PN}"
KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-3"
IUSE="cuneiform minidjvu"
PYTHON_DEPEND="3"

RDEPEND="app-text/djvu
         app-text/tesseract
         dev-lang/python
         media-gfx/imagemagick
         cuneiform? ( app-text/cuneiform )
         minidjvu? ( app-text/minidjvu )"

pkg_setup() {
    python_set_active_version 3
}

src_install() {
    distutils_src_install
}
