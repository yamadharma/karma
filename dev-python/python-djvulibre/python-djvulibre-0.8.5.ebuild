# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/dnspython/dnspython-1.8.0.ebuild,v 1.8 2010/08/16 16:50:27 grobian Exp $

EAPI="5"
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="python-djvulibre is a set of Python bindings for the DjVuLibre library, an open source implementation of DjVu"
HOMEPAGE="http://jwilk.net/software/python-djvulibre"
SRC_URI="https://github.com/jwilk/python-djvulibre/archive/${PV}.tar.gz -> ${P}.tar.gz"
# SRC_URI="http://pypi.python.org/packages/source/p/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-solaris"
IUSE=""

DEPEND=""
RDEPEND="app-text/djvu"

DOCS="doc/changelog"

