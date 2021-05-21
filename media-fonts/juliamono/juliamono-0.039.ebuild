# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="JuliaMono - a monospaced font for scientific and technical computing"
HOMEPAGE="https://juliamono.netlify.app/"
SRC_URI="https://github.com/cormullion/${PN}/releases/download/v${PV}/JuliaMono-ttf.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"

LICENSE="OFL"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 x86 ~amd64-linux ~x86-linux ~x64-macos"

BDEPEND="app-arch/unzip"

FONT_SUFFIX="ttf"
