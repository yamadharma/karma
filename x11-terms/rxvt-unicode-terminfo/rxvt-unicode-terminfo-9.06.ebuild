# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Provides terminfo for rxvt-unicode if rxvt-unicode is not installed"
HOMEPAGE="http://software.schmorp.de/"

PARENT_P="${P/-terminfo/}"
PARENT_PN="${PN/-terminfo/}"
SRC_URI="http://dist.schmorp.de/rxvt-unicode/${PARENT_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="sys-libs/ncurses"
RDEPEND="!x11-terms/rxvt-unicode"

S="${WORKDIR}"/"${PARENT_P}"

src_compile() {
	return
}

src_install() {
	dodoc doc/etc/*
	/usr/bin/tic -o "${D}/usr/share/terminfo" doc/etc/rxvt-unicode.terminfo
}
