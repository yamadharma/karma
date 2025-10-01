# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/dnspython/dnspython-1.8.0.ebuild,v 1.8 2010/08/16 16:50:27 grobian Exp $

EAPI="8"
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{7..13} )

inherit distutils-r1

DESCRIPTION="python-djvulibre is a set of Python bindings for the DjVuLibre library, an open source implementation of DjVu"
HOMEPAGE="https://djvulibre-python.readthedocs.io/
		https://github.com/FriedrichFroebel/python-djvulibre
		"
SRC_URI="https://github.com/FriedrichFroebel/python-djvulibre/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
# SRC_URI="http://pypi.python.org/packages/source/p/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-solaris"
IUSE=""

DEPEND=""
RDEPEND="app-text/djvu"

DOCS="doc/changelog"
