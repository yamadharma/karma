# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FONTDIR_BIN=( OTF TTF )
HELPER_ARGS=( mutatormath )
FONT_SRCDIR=.
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rubjo/${PN}.git"
else
#	SRC_URI="https://rubjo.github.io/victor-mono/VictorMonoAll.zip -> ${P}.zip"
	SRC_URI="https://github.com/rubjo/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tag.gz"
	KEYWORDS="amd64 ~x86"
	S="${WORKDIR}"
fi
inherit font

DESCRIPTION="A free programming font with cursive italics and ligatures"
HOMEPAGE="https://rubjo.github.io/victor-mono"

LICENSE="MIT"
SLOT="0"
IUSE=""
BDEPEND="
"
S="${WORKDIR}"
FONT_S="${S}/OTF"
FONT_SUFFIX="otf"