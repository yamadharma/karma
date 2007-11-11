# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="An A/52 (AC-3) audio encoder"
HOMEPAGE="http://aften.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2 BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=dev-util/cmake-2.4"
RDEPEND=""

src_compile() {
	mkdir default
	cd default
	cmake .. \
		-DCMAKE_C_COMPILER=$(type -P $(tc-getCC)) \
		-DCMAKE_C_FLAGS="${CFLAGS}" \
		-DCMAKE_CXX_COMPILER=$(type -P $(tc-getCXX)) \
		-DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
		-DCMAKE_SHARED=1 \
		-DBINDINGS_CXX=1 \
		-DCMAKE_INSTALL_PREFIX=/usr \
		|| die "cmake failed"

	emake || die "emake failed"
}

src_install() {
	cd default
	emake DESTDIR="${D}" install || die "emake install failed"
	cd ..
	dodoc README Changelog
}
