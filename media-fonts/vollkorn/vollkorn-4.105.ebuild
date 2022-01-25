# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="The free and healthy typeface for bread and butter use"
HOMEPAGE="http://vollkorn-typeface.com"
SRC_URI="http://vollkorn-typeface.com/download/${PN}-$(ver_rs 1 -).zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

BDEPEND="app-arch/unzip"

S="${WORKDIR}"
FONT_S="${S}/TTF"
FONT_SUFFIX="ttf otf"
DOCS="Fontlog.txt"

src_prepare() {
	default
	mv "${S}"/PS-OTF/*.otf "${FONT_S}" || die
}
