# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="An assortment of general purpose CMake scripts "
HOMEPAGE="https://github.com/oblivioncth/OBCmake"
SRC_URI="https://github.com/oblivioncth/OBCmake/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/0"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc ppc64 ~riscv ~sparc x86"

IUSE=""

S=${WORKDIR}/OBCmake-${PV}

src_install() {
	cd ${S}
	dodir /usr/share/cmake/Modules
	cp -R cmake/module/* ${D}/usr/share/cmake/Modules
	cmake --install .
}
