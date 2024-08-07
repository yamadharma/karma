# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
#MUPDF_PV=1.23.10
MUPDF_PV=1.24.1
ZLIB_PV=1.3.1

inherit qmake-utils desktop xdg

if [[ ${PV##*.} != 9999 ]]; then
	SRC_URI="
		https://github.com/ahrm/sioyek/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
		https://github.com/ArtifexSoftware/mupdf/archive/refs/tags/${MUPDF_PV}.tar.gz -> mupdf-${MUPDF_PV}.tar.gz
		https://github.com/madler/zlib/archive/refs/tags/v${ZLIB_PV}.tar.gz -> zlib-${ZLIB_PV}.tar.gz
		"
	KEYWORDS="~amd64"
else
#	SRC_URI="
#		https://github.com/ArtifexSoftware/mupdf/archive/refs/tags/${MUPDF_PV}.tar.gz -> mupdf-${MUPDF_PV}.tar.gz
#		https://github.com/madler/zlib/archive/refs/tags/v${ZLIB_PV}.tar.gz -> zlib-${ZLIB_PV}.tar.gz
#		"
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ahrm/sioyek.git"
	EGIT_BRANCH=development
	KEYWORDS="~amd64"
fi

DESCRIPTION="Sioyek is a PDF viewer with a focus on textbooks and research papers"
HOMEPAGE="https://github.com/ahrm/sioyek"

LICENSE="GPL-3"
SLOT="0"

BDEPEND="
	media-libs/harfbuzz
	dev-qt/qtbase:6
	dev-qt/qt3d:6
"

PATCHES=(
	"${FILESDIR}/epub-support.patch"
	"${FILESDIR}/sqlite3-fix-1.patch"
	"${FILESDIR}/sqlite3-fix-2.patch"
	"${FILESDIR}/sqlite3-fix-3.patch"
	)

#	"${FILESDIR}/mupdf-1.23.patch"
#	"${FILESDIR}/fuzzy-smart-case.patch"

src_prepare() {
	default

	rm -r "${S}/mupdf" "${S}/zlib" || die

	if [[ ${PV##*.} != 9999 ]]; then
		rm -r "${S}/mupdf" "${S}/zlib" || die
		mv "${WORKDIR}/mupdf-${MUPDF_PV}" "${S}/mupdf" || die
		mv "${WORKDIR}/zlib-${ZLIB_PV}" "${S}/zlib" || die
	fi

	## Fix for new mupdf
	sed -i -e 's/-lmupdf-third//g' pdf_viewer_build_config.pro

	## Move /etc
	sed -i -e 's:$$PREFIX/etc:/etc:g' pdf_viewer_build_config.pro
}

src_compile() {
	#Make Mupdf specific for build
#	pushd mupdf || die
#	emake USE_SYSTEM_HARFBUZZ=yes
#	popd || die

	eqmake6 pdf_viewer_build_config.pro
	emake
}

src_install() {
	make install INSTALL_ROOT=${D}
	#intall bin and shaders
#	dobin sioyek
#	insinto /usr/share/sioyek/shaders
#	doins pdf_viewer/shaders/*

#	domenu "${FILESDIR}/sioyek.desktop"
#	doicon resources/sioyek-icon-linux.png
#	insinto /usr/share/sioyek && doins tutorial.pdf pdf_viewer/keys.config pdf_viewer/prefs.config
#	doman resources/sioyek.1
}

pkg_postinst() {
	xdg_desktop_database_update
}
