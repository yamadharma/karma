# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/dnspython/dnspython-1.8.0.ebuild,v 1.8 2010/08/16 16:50:27 grobian Exp $

EAPI="2"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="djvusmooth is a graphical editor for DjVu documents"
HOMEPAGE="http://jwilk.net/software/ocrodjvu"
SRC_URI="http://pypi.python.org/packages/source/o/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-solaris"
IUSE="cuneiform gocr ocrad ocropus tesseract"

DEPEND=""
RDEPEND="dev-python/python-djvulibre
	dev-python/lxml
 	dev-python/pyicu
	cuneiform? ( app-text/cuneiform )
	gocr? ( app-text/gocr )
	ocropus? ( app-text/ocropus )
	tesseract? ( app-text/tesseract )
	ocrad? ( app-text/ocrad )"

#	dev-python/argparse

RESTRICT="nomirror"

RESTRICT_PYTHON_ABIS="3.*"

#PYTHON_MODNAME="dns"
DOCS="doc/changelog doc/*.xml doc/dependencies.txt"

src_install() {
	distutils_src_install

	doman doc/*.1
}

