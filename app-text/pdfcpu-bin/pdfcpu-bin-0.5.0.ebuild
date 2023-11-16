# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit bash-completion-r1

DESCRIPTION="A PDF processor written in Go"
HOMEPAGE="https://github.com/pdfcpu/pdfcpu"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/pdfcpu/pdfcpu.git"
else
	SRC_URI="amd64? ( https://github.com/pdfcpu/pdfcpu/releases/download/v${PV}/${PN/-bin/}_${PV}_Linux_x86_64.tar.xz )"
	KEYWORDS="amd64"
	S=${WORKDIR}/${PN/-bin/}_${PV}_Linux_x86_64
fi

LICENSE="Apache-2.0"
SLOT="0"

RDEPEND=""

RESTRICT="test"

src_compile() {
	:;
}

src_install() {
	dobin ${S}/${PN/-bin/}
}
