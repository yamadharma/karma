# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="xkcd script font"
HOMEPAGE="https://github.com/ipython/xkcd-font"
SRC_URI="https://github.com/ipython/xkcd-font/blob/master/xkcd-script/font/xkcd-script.ttf?raw=true -> xkcd-script-${PV}.ttf"
S="${WORKDIR}"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 ~loong ~riscv ~x86"

FONT_SUFFIX="ttf"

src_unpack() {
	cp "${DISTDIR}/${A}" "${S}/${PN}.${FONT_SUFFIX}" || die
}
