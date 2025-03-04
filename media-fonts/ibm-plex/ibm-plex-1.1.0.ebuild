# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="The package of IBM's typeface"
HOMEPAGE="https://github.com/IBM/plex"
SRC_URI="
https://github.com/IBM/plex/releases/download/@ibm/plex-serif@${PV}/ibm-plex-serif.zip -> ibm-plex-serif-${PV}.zip
https://github.com/IBM/plex/releases/download/@ibm/plex-sans@${PV}/ibm-plex-sans.zip -> ibm-plex-sans-${PV}.zip
https://github.com/IBM/plex/releases/download/@ibm/plex-sans-thai@${PV}/ibm-plex-sans-thai.zip -> ibm-plex-sans-thai-${PV}.zip
https://github.com/IBM/plex/releases/download/@ibm/plex-sans-thai-looped@${PV}/ibm-plex-sans-thai-looped.zip -> ibm-plex-sans-thai-looped-${PV}.zip
https://github.com/IBM/plex/releases/download/@ibm/plex-sans-kr@${PV}/ibm-plex-sans-kr.zip -> ibm-plex-sans-kr-${PV}.zip
https://github.com/IBM/plex/releases/download/@ibm/plex-sans-jp@${PV}/ibm-plex-sans-jp.zip -> ibm-plex-sans-jp-${PV}.zip
https://github.com/IBM/plex/releases/download/@ibm/plex-sans-hebrew@${PV}/ibm-plex-sans-hebrew.zip -> ibm-plex-sans-hebrew-${PV}.zip
https://github.com/IBM/plex/releases/download/@ibm/plex-sans-devanagari@${PV}/ibm-plex-sans-devanagari.zip -> ibm-plex-sans-devanagari-${PV}.zip
https://github.com/IBM/plex/releases/download/@ibm/plex-sans-condensed@${PV}/ibm-plex-sans-condensed.zip -> ibm-plex-sans-condensed-${PV}.zip
https://github.com/IBM/plex/releases/download/@ibm/plex-sans-arabic@${PV}/ibm-plex-sans-arabic.zip -> ibm-plex-sans-arabic-${PV}.zip
https://github.com/IBM/plex/releases/download/@ibm/plex-mono@${PV}/ibm-plex-mono.zip -> ibm-plex-mono-${PV}.zip
https://github.com/IBM/plex/releases/download/@ibm/plex-math@${PV}/ibm-plex-math.zip -> ibm-plex-math-${PV}.zip
"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 ~loong ~riscv x86"
IUSE="otf +ttf"

REQUIRED_USE="^^ ( otf ttf )"

S="${WORKDIR}"

# DOCS=( README.md )

FONT_SUFFIX=""

src_install() {

if use otf; then

	FONT_SUFFIX+="otf"

	FONT_S=(
		ibm-plex-serif/fonts/complete/otf
		ibm-plex-sans/fonts/complete/otf
		ibm-plex-sans-thai/fonts/complete/otf
		ibm-plex-sans-thai-looped/fonts/complete/otf
		ibm-plex-sans-kr/fonts/complete/otf
		ibm-plex-sans-jp/fonts/complete/otf/hinted
		ibm-plex-sans-hebrew/fonts/complete/otf
		ibm-plex-sans-devanagari/fonts/complete/otf
		ibm-plex-sans-condensed/fonts/complete/otf
		ibm-plex-sans-arabic/fonts/complete/otf
		ibm-plex-mono/fonts/complete/otf
		ibm-plex-math/fonts/complete/otf
	)
fi

if use ttf; then

	FONT_SUFFIX+="ttf"

	FONT_S=(
		ibm-plex-serif/fonts/complete/ttf
		ibm-plex-sans/fonts/complete/ttf
		ibm-plex-sans-thai/fonts/complete/ttf
		ibm-plex-sans-thai-looped/fonts/complete/ttf
		ibm-plex-sans-kr/fonts/complete/ttf
		ibm-plex-sans-jp/fonts/complete/ttf/hinted
		ibm-plex-sans-hebrew/fonts/complete/ttf
		ibm-plex-sans-devanagari/fonts/complete/ttf
		ibm-plex-sans-condensed/fonts/complete/ttf
		ibm-plex-sans-arabic/fonts/complete/ttf
		ibm-plex-mono/fonts/complete/ttf
		ibm-plex-math/fonts/complete/ttf
	)
fi

font_src_install

}
