# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/eugmes/${PN}.git"
	# KEYWORDS="~amd64 ~x86"
else
	SRC_URI="https://github.com/eugmes/${PN}/archive/refs/tags/release/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~x86"
	S="${WORKDIR}/${PN}-release-${PV}"
fi

DESCRIPTION="A program for making font samples that show Unicode coverage of the font"
HOMEPAGE="https://github.com/eugmes/${PN}"

LICENSE="GPL-3+"
SLOT="0"
IUSE="+perl"

DEPEND="
	media-libs/fontconfig
	media-libs/freetype:2
	x11-libs/cairo
	x11-libs/pango
	app-i18n/unicode-data
"
RDEPEND="
	${DEPEND}
	perl? ( dev-perl/PDF-API2 )
"
BDEPEND="
	virtual/pkgconfig
	sys-devel/gettext
"

src_configure() {
	local mycmakeargs=(
		-DUNICODE_BLOCKS=${EPREFIX}/usr/share/unicode-data/Blocks.txt
	)
	cmake_src_configure
}
