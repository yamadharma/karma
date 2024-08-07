# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="PyMuPDF is a high performance Python library for data extraction, analysis, conversion and manipulation of PDF (and other) documents."
HOMEPAGE="
	https://github.com/pymupdf/PyMuPDF
	https://pypi.org/project/PyMuPDF/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

DEPEND="
	=app-text/mupdf-${PV}*
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
"

distutils_enable_tests unittest

src_prepare() {
	default
	sed -i -e '/build-backend =.*/d' pyproject.toml
}