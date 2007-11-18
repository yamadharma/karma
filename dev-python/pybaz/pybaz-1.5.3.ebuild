# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Python bindings for the Bazaar revision control system."
HOMEPAGE="http://code.aaronbentley.com/pybaz/"
SRC_URI="http://code.aaronbentley.com/pybaz/releases/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
IUSE=""

DOCS="CHANGES CODING COPYING README"

RDEPEND="dev-lang/python
	<dev-python/twisted-2.2
	dev-util/bazaar"

DEPEND="${RDEPEND}"
