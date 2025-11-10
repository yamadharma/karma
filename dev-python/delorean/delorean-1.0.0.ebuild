# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Delorean: Time Travel Made Easy"
HOMEPAGE="
	https://github.com/myusuf3/delorean
"
SRC_URI="https://github.com/myusuf3/delorean/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
"

distutils_enable_tests pytest
