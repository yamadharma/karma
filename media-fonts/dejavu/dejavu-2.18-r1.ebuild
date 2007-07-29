# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit font versionator nfont 

MY_P="${PN/dejavu/dejavu-ttf}-$(replace_version_separator 2 -)"
AUX_V=""

DESCRIPTION="DejaVu fonts, bitstream vera with wider range of characters"
HOMEPAGE="http://dejavu.sourceforge.net/"
LICENSE="BitstreamVera"
SRC_URI="mirror://sourceforge/dejavu/${MY_P}${AUX_V}.tar.bz2"

SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE="gnustep"

NFONT=${PN}.nfont.tar.bz2

DOCS="AUTHORS BUGS NEWS README status.txt langcover.txt unicover.txt"
FONT_SUFFIX="ttf"
S="${WORKDIR}/${MY_P}"
FONT_S="${S}"

# Only installs fonts
RESTRICT="strip binchecks"

FONT_CONF="59-dejavu.conf"

src_install ()
{
	font_src_install
	use gnustep && nfont_src_install
}

