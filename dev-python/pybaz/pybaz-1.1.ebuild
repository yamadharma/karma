# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils python

DESCRIPTION="Python bindings for the Bazaar revision control system."
HOMEPAGE="http://ddaa.net/pybaz.html"
SRC_URI="http://ddaa.net/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="doc"

RDEPEND=">=dev-lang/python-2.3
	dev-util/bazaar"

PYTHON_MODNAME="pybaz"

