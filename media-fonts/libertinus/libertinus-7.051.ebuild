# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

MY_P="Libertinus-${PV}"

DESCRIPTION="A fork of the Linux Libertine and Linux Biolinum fonts"
HOMEPAGE="https://github.com/alerque/libertinus"
SRC_URI="https://github.com/alerque/libertinus/releases/download/v${PV}/${MY_P}.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

S="${WORKDIR}/${MY_P}"
FONT_S="${S}/static/OTF"
FONT_SUFFIX="otf"
DOCS="AUTHORS.txt CONTRIBUTORS.txt FONTLOG.txt README.md documentation/*"
