# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )

inherit distutils-r1

DESCRIPTION="BibTeX-compatible bibliography processor in Python"
HOMEPAGE="https://pybtex.org/"
#SRC_URI="https://pypi.python.org/packages/82/59/d46b4a84faacd7c419cfc9a442b7940d6d625d127b83d83666e2a8b203d8/pybtex-0.21.tar.gz"
#SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"
#SRC_URI="https://bitbucket.org/pybtex-devs/${PN}/get/${PV}.tar.bz2 -> ${P}.tar.bz2"
SRC_URI="https://files.pythonhosted.org/packages/source/p/pybtex/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE="doc examples"
KEYWORDS="x86 amd64"

RESTRICT="test"

RDEPEND="dev-python/pyparsing
	dev-python/pyyaml
	dev-python/six
	dev-python/latexcodec
	"

DEPEND="dev-python/setuptools
	"

src_prepare() {
	sed -i -e "s/find_packages(exclude=\['docs'\])/find_packages(exclude=['docs','tests*'])/" setup.py || die
	default
}

src_install() {
	distutils-r1_src_install

	doman docs/man1/pybtex.1 docs/man1/pybtex-convert.1
	use doc && dohtml docs/html/*

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}

src_test() {
	${python} setup.py nosetests
}
