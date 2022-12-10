# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} pypy3 )
inherit distutils-r1

DESCRIPTION="This library is a port of requests-oauthlib for aiohttp."
HOMEPAGE="https://git.sr.ht/~whynothugo/aiohttp-oauthlib"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	>=dev-python/aiohttp-2.3.9[${PYTHON_USEDEP}]
	>=dev-python/jinja-3[${PYTHON_USEDEP}]
"
BDEPEND="
"

