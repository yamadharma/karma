# Copyright 1999-2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=8

inherit cmake

CMAKE_MAKEFILE_GENERATOR=emake

DESCRIPTION="Freelib is book library manager"
HOMEPAGE="https://github.com/petrovvlad/freeLib"
if [[ ${PV##*.} != 9999 ]]; then
	SRC_URI="https://github.com/petrovvlad/freeLib/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64"
	S=${WORKDIR}/freeLib-${PV}
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/petrovvlad/freeLib.git"
	EGIT_BRANCH=master
	KEYWORDS="amd64"
fi


LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE=""



RDEPEND="
	dev-qt/qtbase:6
	dev-qt/qtsvg:6
	dev-qt/qthttpserver:6
	dev-qt/qt5compat:6
	dev-qt/qtwebsockets:6
	dev-libs/quazip[qt6]
	"

DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DFREELIB_QT_MAJOR_VERSION=6
		-DCMAKE_BUILD_TYPE=Release		
	)
	
	# cmake_src_configure
	mkdir -p ${S}_build
	cd ${S}_build
	cmake ${S} ${mycmakeargs} -DCMAKE_INSTALL_PREFIX=/usr
}
