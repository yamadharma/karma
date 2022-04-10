# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="XOAUTH2 mechanism plugin for cyrus-sasl"
HOMEPAGE="https://github.com/moriyoshi/cyrus-sasl-xoauth2"
LICENSE="GPL-2"
SLOT="0"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/moriyoshi/cyrus-sasl-xoauth2.git"
	inherit git-r3 autotools
else
	SRC_URI="https://github.com/moriyoshi/${PN}/archive/refs/tags/v${PV}.tar.gz"
	KEYWORDS="amd64 arm arm64 ~ppc ~ppc64 ~riscv x86"
fi

IUSE=""

RDEPEND="
	dev-libs/cyrus-sasl
"
DEPEND=${RDEPEND}
BDEPEND="
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	default
	econf
}

src_install() {
	default
	mv ${D}/usr/lib ${D}/usr/lib64
}