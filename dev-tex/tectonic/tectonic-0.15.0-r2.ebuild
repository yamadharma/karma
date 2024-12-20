# Copyright 2023-2024 Robert Günzler
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A modernized, complete, self-contained TeX/LaTeX engine."
HOMEPAGE="https://tectonic-typesetting.github.io/"
SRC_URI="https://github.com/tectonic-typesetting/tectonic/releases/download/tectonic@${PV}/tectonic-${PV}-x86_64-unknown-linux-gnu.tar.gz"

LICENSE="Apache-2.0 Artistic-2 BSD-2 BSD CC0-1.0 ISC MIT WTFPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-libs/icu
	dev-libs/openssl
	media-gfx/graphite2
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/harfbuzz[graphite,icu]
	media-libs/libpng
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

S=${WORKDIR}

src_install() {
	dobin tectonic
}
