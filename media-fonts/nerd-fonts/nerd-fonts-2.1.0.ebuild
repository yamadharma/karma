# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font check-reqs

DESCRIPTION="Collection of fonts that are patched to include a high number of glyphs (icons)."
HOMEPAGE="https://nerdfonts.com
https://github.com/ryanoasis/nerd-fonts/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"

DIRNAME=(
	3270
	Agave
	AnonymousPro
	Arimo
	AurulentSansMono
	BigBlueTerminal
	BitstreamVeraSansMono
	CascadiaCode
	CodeNewRoman
	Cousine
	DejaVuSansMono
	DroidSansMono
	FantasqueSansMono
	FiraCode
	FiraMono
	Go-Mono
	Gohu
	Hack
	Hasklig
	HeavyData
	Hermit
	iA-Writer
	IBMPlexMono
	Inconsolata
	InconsolataGo
	InconsolataLGC
	Iosevka
	JetBrainsMono
	Lekton
	LiberationMono
	Meslo
	Monofur
	Monoid
	Mononoki
	MPlus
	Noto
	OpenDyslexic
	Overpass
	ProFont
	ProggyClean
	RobotoMono
	ShareTechMono
	SourceCodePro
	SpaceMono
	Terminus
	Tinos
	Ubuntu
	UbuntuMono
	VictorMono
)

SRC_URI=""

for i in ${DIRNAME[@]}
do
SRC_URI="${SRC_URI}
	https://github.com/ryanoasis/${PN}/releases/download/v${PV}/${i}.zip -> nerd-fonts-${i}-${PV}.zip"
done

#IUSE_FLAGS=(${DIRNAME[*],,})
#IUSE="${IUSE_FLAGS[*]}"
#REQUIRED_USE="|| ( ${IUSE_FLAGS[*]} )"

DEPEND="app-arch/unzip
	net-misc/wget"
RDEPEND="media-libs/fontconfig"

CHECKREQS_DISK_BUILD="3G"
CHECKREQS_DISK_USR="4G"

S="${WORKDIR}"
FONT_CONF=(
	${FILESDIR}/10-nerd-font-symbols.conf
)
FONT_S=${S}

pkg_pretend() {
	check-reqs_pkg_setup
}

src_install() {
	declare -A font_filetypes
	local otf_file_number ttf_file_number

	otf_file_number=$(ls ${S} | grep -i otf | wc -l)
	ttf_file_number=$(ls ${S} | grep -i ttf | wc -l)

	if [[ ${otf_file_number} != 0 ]]; then
		font_filetypes[otf]=
	fi

	if [[ ${ttf_file_number} != 0 ]]; then
		font_filetypes[ttf]=
	fi

	FONT_SUFFIX="${!font_filetypes[@]}"

	font_src_install
}

pkg_postinst() {
	einfo "Installing font-patcher via an ebuild is hard, because paths are hardcoded differently"
	einfo "in .sh files. You can still get it and use it by git cloning the nerd-font project and"
	einfo "running it from the cloned directory."
	einfo "https://github.com/ryanoasis/nerd-fonts"

	elog "You might have to enable 50-user.conf and 10-nerd-font-symbols.conf by using"
	elog "eselect fontconfig"
}
