# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit eutils python versionator

MY_PN="${PN/pylucene/PyLucene}"
MY_PV=$(replace_version_separator 3 '-')
MY_P=${MY_PN}-${MY_PV}-src-jcc

S="${WORKDIR}/${MY_P}"

DESCRIPTION="Python bindings od Lucene search engine"
HOMEPAGE="http://pylucene.osafoundation.org/"
SRC_URI="http://downloads.osafoundation.org/PyLucene/jcc/${MY_P}.tar.gz"
RESTRICT="nomirror test"

LICENSE="MIT"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="virtual/python
	dev-java/lucene:2.3
	dev-java/lucene-analyzers:2.3
	dev-java/lucene-highlighter:2.3
	dev-java/lucene-queries:2.3
	dev-java/lucene-regex:2.3"

RDEPEND=""
	
python_version

pkg_setup() {
	built_with_use sys-devel/gcc gcj || die "PyLucene requires gcj compiler"
}

src_compile() {
	make PYTHON_VER=${PYVER} \
	     PREFIX=/usr PREFIX_PYTHON=/usr \
		 GCJ_HOME=/usr GCJ_LIBDIR=/usr/lib GCJ_STATIC=0 \
		 CC=${CC-gcc} CXX=${CXX-g++} JCC=gcj JCCH=gcjh JAR=gcj-jar \
		 all || die
}

src_install() {
	if [ -f /usr/bin/gcc-config ] ; then
		GCC_LDPATH=$(gcc-config -L | sed 's#:.*$##')
	else
		GCC_LDPATH=`eselect compiler getval LDPATH`
	fi

	dodoc CHANGES CREDITS LICENSE README

	dodir /usr/lib/python${PYVER}/site-packages
	emake GCJ_LIBDIR=${GCC_LDPATH} PYTHON_VER=${PYVER} PREFIX_PYTHON=${D}/usr \
	      install || die
}

pkg_postinst() {
	python_version
	python_mod_optimize /usr/lib/python${PYVER}/site-packages
}

pkg_postrm() {
	python_version
	python_mod_cleanup /usr/lib/python${PYVER}/site-packages
}
