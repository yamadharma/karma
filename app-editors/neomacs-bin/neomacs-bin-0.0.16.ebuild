# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="GPU powered Emacs written in Rust with a modern display engine"
HOMEPAGE="https://github.com/eval-exec/neomacs"
SRC_URI="https://github.com/eval-exec/neomacs/releases/download/v${PV}/neomacs-${PV}-x86_64-unknown-linux-gnu.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	media-libs/mesa
	x11-libs/libxcb
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/neomacs-${PV}-x86_64-unknown-linux-gnu"

src_install() {
	dodir /usr
	cp -R bin ${D}/usr
	cp -R libexec ${D}/usr
	cp -R share ${D}/usr

	dodoc COPYING README.md VERSION
}
