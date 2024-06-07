# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..12} )

# pass-import makes only one Python implementation, needs PYTHON_SINGLE_TARGET.
inherit distutils-r1

DESCRIPTION="generic importer extension for password manager ZX2C4's pass"
HOMEPAGE="https://github.com/roddhjav/pass-import"
SRC_URI="https://github.com/roddhjav/pass-import/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~x86"

COMMON_DEPEND="app-shells/bash
	dev-python/dominate
	$(python_gen_cond_dep '
		dev-python/cryptography[${PYTHON_USEDEP}]
	')
	$(python_gen_cond_dep '
		dev-python/defusedxml[${PYTHON_USEDEP}]
	')
	|| (
		$(python_gen_cond_dep '
			sys-apps/file[python,${PYTHON_USEDEP}]
		')
		$(python_gen_cond_dep '
			dev-python/python-magic[${PYTHON_USEDEP}]
		')
	)
	$(python_gen_cond_dep '
		dev-python/pyyaml[${PYTHON_USEDEP}]
	')
	$(python_gen_cond_dep '
		dev-python/secretstorage[${PYTHON_USEDEP}]
	')"
DEPEND="${COMMON_DEPEND}
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
	')
	"
RDEPEND="${COMMON_DEPEND}
	>=app-admin/pass-1.7.0"

RESTRICT="mirror"

DOCS=( CHANGELOG.rst CONTRIBUTING.rst README.md )

pkg_setup() {
        python_setup
}

src_prepare() {
	eapply_user
	python_fix_shebang .
	sed -i -e 's:python3:'${EPYTHON}':g' scripts/import.bash scripts/pimport
}

src_compile() {
	pandoc -t man -s -o share/man/man1/pass-import.1 share/man/man1/pass-import.md
	pandoc -t man -s -o share/man/man1/pimport.1 share/man/man1/pimport.md 
}

src_install() {
	default
	python_domodule pass_import
}

pkg_postinst() {
	elog "If you want to import passwords from KeePass, install pykeepass."
	elog "https://pypi.org/project/pykeepass/"
}