# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/sazanami/sazanami-20040629.ebuild,v 1.8 2004/12/20 13:40:44 nigoro Exp $

inherit font

DESCRIPTION="Sazanami Japanese TrueType fonts"
HOMEPAGE="ftp://ftp.citkit.ru/pub/fonts_kit"
SRC_URI="ftp://ftp.citkit.ru/pub/fonts_kit/${P}.tar.bz2"

S=${WORKDIR}/${PN}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 alpha ppc ppc64 ~ppc-macos amd64 sparc"
IUSE=""



FONT_SUFFIX="ttf"

DOCS="docs/README"

#src_install() {
#
#	font_src_install
#
#	cd doc
#	for d in oradano misaki mplus shinonome ayu kappa; do
#		docinto $d
#		dodoc $d/*
#	done
#
#}
