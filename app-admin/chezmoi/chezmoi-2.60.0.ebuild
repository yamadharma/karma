# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker shell-completion

MY_PN="${PN%-bin}"

DESCRIPTION="Manage your dotfiles across multiple machines, securely."
HOMEPAGE="https://github.com/twpayne/chezmoi"
SRC_URI="
	amd64? ( https://github.com/twpayne/${MY_PN}/releases/download/v${PV}/${MY_PN}_${PV}_linux_amd64.deb )
	arm? ( https://github.com/twpayne/${MY_PN}/releases/download/v${PV}/${MY_PN}_${PV}_linux_armel.deb )
	arm64? ( https://github.com/twpayne/${MY_PN}/releases/download/v${PV}/${MY_PN}_${PV}_linux_arm64.deb )
	ppc64? ( https://github.com/twpayne/${MY_PN}/releases/download/v${PV}/${MY_PN}_${PV}_linux_ppc64.deb )
	x86? ( https://github.com/twpayne/${MY_PN}/releases/download/v${PV}/${MY_PN}_${PV}_linux_i386.deb )"

LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
RDEPEND="dev-vcs/git"
SLOT="0"

RESTRICT="mirror strip"

QA_PREBUILT="
	usr/bin/${MY_PN}"

S="${WORKDIR}"

src_unpack() {
	unpack_deb "${A}"
}

src_install() {
	default

	dobin usr/bin/chezmoi

	insinto /usr/share/bash-completion/completions
	doins usr/share/bash-completion/completions/chezmoi

	insinto /usr/share/zsh/vendor-completions
	doins usr/share/zsh/vendor-completions/_chezmoi

	insinto /usr/share/fish/vendor_completions.d
	doins usr/share/fish/vendor_completions.d/chezmoi.fish


#	insinto /
#	doins -r *
#	fperms +x /usr/bin/${MY_PN}

#	newbashcomp completions/${PN}-completion.bash ${PN}
#	dofishcomp completions/${PN}.fish
#	newzshcomp completions/${PN}.zsh _${PN}
}
