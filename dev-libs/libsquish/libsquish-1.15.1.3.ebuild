# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="The squish library (abbreviated to libsquish) is an open source DXT compression library written in C++"
HOMEPAGE="https://oblivioncth.github.io/libsquish/"
SRC_URI="https://github.com/oblivioncth/libsquish/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/0"
#KEYWORDS="amd64 ~arm arm64 ~loong ~ppc ppc64 ~riscv ~sparc x86"

# RESTRICT="network-sandbox"

DEPEND="dev-util/obcmake"

IUSE=""

# src_configure() {
# 	local mycmakeargs=(
# 		-DYYJSON_BUILD_DOC=$(usex doc)
# 		-DYYJSON_BUILD_TESTS=$(usex test)
# 		-DYYJSON_ENABLE_VALGRIND=OFF
# 	)

# 	cmake_src_configure
# }

# src_install() {
# 	cmake_src_install

# 	use doc && dodoc -r "${BUILD_DIR}"/doxygen/html
# }
