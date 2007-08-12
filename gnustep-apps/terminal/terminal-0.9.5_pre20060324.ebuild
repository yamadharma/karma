# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

S=${WORKDIR}/${PN/t/T}

DESCRIPTION="A terminal emulator for GNUstep"
HOMEPAGE="http://www.nongnu.org/terminal/"
SRC_URI="http://overlays.gentoo.org/svn/proj/gnustep/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc x86"
SLOT="0"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# on Solaris -lutil doesn't exist, which hence doesn't provide forkpty
	epatch "${FILESDIR}"/${P}-solaris.patch
	epatch "${FILESDIR}"/${P}-size_t.patch
}
