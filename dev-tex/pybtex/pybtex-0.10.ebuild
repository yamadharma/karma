NEED_PYTHON=2.5

inherit distutils

DESCRIPTION="BibTeX-compatible bibliography processor in Python"
HOMEPAGE="http://pybtex.sourceforge.net/"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
IUSE="doc examples"
KEYWORDS="x86 amd64"

RDEPEND="dev-python/pyparsing
	dev-python/pyyaml"

DEPEND="dev-python/setuptools
	test? (
		dev-python/nose
		${RDEPEND}
	)"

src_install() {
	distutils_src_install

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
