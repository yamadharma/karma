# Copyright 2018-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..13} )
DISTUTILS_USE_PEP517=setuptools

inherit bash-completion-r1 distutils-r1

DESCRIPTION="A pass extension for auditing your password repository"
HOMEPAGE="https://github.com/roddhjav/pass-audit"
SRC_URI="https://github.com/roddhjav/pass-audit/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"
IUSE=""
RESTRICT="test"

DEPEND=""

RDEPEND=">=app-admin/pass-1.7
	dev-python/requests
	"
#	dev-python/zxcvbn

src_install() {
	default
	distutils-r1_src_install

#	emake install DESTDIR="${D}" BASHCOMPDIR="$(get_bashcompdir)"
	
}

