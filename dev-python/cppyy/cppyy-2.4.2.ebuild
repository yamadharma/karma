# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} pypy3 )
# DISTUTILS_USE_PEP517=setuptools
DISTUTILS_USE_PEP517=

inherit distutils-r1 pypi

DESCRIPTION="cppyy provides fully automatic, dynamic Python-C++ bindings by leveraging the Cling C++ interpreter and LLVM"
HOMEPAGE="https://github.com/afq984/python-cxxfilt"
# SRC_URI="mirror://pypi/c/${PN}/${P}.tar.gz"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ppc ppc64 ~riscv ~s390 sparc x86"
LICENSE="LGPL-3"

BDEPEND="
	test? (
		dev-python/iocapture[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

RESTRICT="network-sandbox"