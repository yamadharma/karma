# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/sympy/sympy-0.7.1.ebuild,v 1.2 2011/08/08 18:37:35 hwoarang Exp $

EAPI="3"

PYTHON_DEPEND="2:2.5"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 3.* *-jython"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils eutils

DESCRIPTION="Computer algebra system (CAS) in Python"
HOMEPAGE="http://code.google.com/p/sympy/"
SRC_URI="http://sympy.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-macos"
IUSE="doc examples gtk imaging ipython latex mathml opengl pdf png test texmacs"

# FIXME: pyglet has been removed and is now a soft dep. Find out how to deal with this.
RDEPEND="
	mathml? (
		dev-libs/libxml2:2[python]
		dev-libs/libxslt[python]
		gtk? ( x11-libs/gtkmathview[gtk] ) )
	latex? (
		virtual/latex-base
		png? ( app-text/dvipng )
		pdf? ( app-text/ghostscript-gpl ) )
	texmacs? ( app-office/texmacs )
	ipython? ( dev-python/ipython )
	opengl? ( dev-python/pyopengl )
	imaging? ( dev-python/imaging )
	>=dev-python/pexpect-2.0
	~dev-python/mpmath-0.17"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx )
	test? ( dev-python/pytest )"

pkg_setup() {
	python_pkg_setup
	export DOT_SAGE="${S}"
}

src_compile() {
	PYTHONPATH="." distutils_src_compile

	if use doc; then
		cd doc
		emake html || die "emake html failed"
	fi
}

src_install() {
	PYTHONPATH="." distutils_src_install

	rm -f "${ED}usr/bin/"{doctest,test} || die "rm doctest test failed"

	if use doc; then
		dohtml -r doc/_build/html/*
	fi

	if use examples; then
		insinto /usr/share/doc/${P}
	    doins -r examples
	fi

	if use texmacs; then
		exeinto /usr/libexec/TeXmacs/bin/
		doexe data/TeXmacs/bin/tm_sympy
		insinto /usr/share/TeXmacs/plugins/sympy/
		doins -r data/TeXmacs/progs
	fi
}
