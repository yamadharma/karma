# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1

DESCRIPTION="Functions to return paths to the directories defined by the XDG Base Directory Specification"
HOMEPAGE="https://github.com/srstevenson/xdg"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"

RDEPEND="!dev-python/pyxdg"
