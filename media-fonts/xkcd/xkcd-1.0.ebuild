# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="xkcd font"
HOMEPAGE="https://github.com/ipython/xkcd-font"
SRC_URI="https://github.com/ipython/xkcd-font/blob/master/xkcd/build/xkcd.otf?raw=true -> xkcd-${PV}.otf
	https://github.com/ipython/xkcd-font/blob/master/xkcd/build/xkcd-Regular.otf?raw=true -> xkcd-Regular-${PV}.otf
	"
S="${WORKDIR}"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 ~loong ~riscv ~x86"

FONT_SUFFIX="otf"

src_unpack() {
	for i in xkcd xkcd-Regular
	do
		cp "${DISTDIR}/${i}"-${PV}.${FONT_SUFFIX} "${S}/${i}".${FONT_SUFFIX} || die
	done
}
