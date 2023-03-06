# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=${PN/-bin/}

DESCRIPTION="Host application for the Bukubrow WebExtension"
# Double check the homepage as the cargo_metadata crate
# does not provide this value so instead repository is used
HOMEPAGE="https://github.com/samhh/bukubrow-host"
SRC_URI="https://github.com/samhh/bukubrow-host/releases/download/v${PV}/bukubrow-linux-amd64 -> ${P}"
# License set may be more restrictive as OR is not respected
# use cargo-license for a more accurate license picture
LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 Boost-1.0 CC0-1.0 MIT Unlicense"
SLOT="0"
KEYWORDS="amd64"
RESTRICT="primaryuri"

src_unpack () {
	mkdir ${S}
	cp ${DISTDIR}/${P} ${S}/${MY_PN}
}

src_install () {
	dobin ${MY_PN}
}
