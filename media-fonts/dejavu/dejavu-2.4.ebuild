# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/dejavu/dejavu-2.0.ebuild,v 1.1 2005/12/04 04:44:41 usata Exp $

inherit font versionator nfont 

MY_P="${P/dejavu/dejavu-ttf}"
AUX_V=""

DESCRIPTION="DejaVu fonts, bitstream vera with ISO-8859-2 characters"
HOMEPAGE="http://dejavu.sourceforge.net/"
LICENSE="BitstreamVera"
SRC_URI="mirror://sourceforge/dejavu/${MY_P}${AUX_V}.tar.gz"

SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE="gnustep"

NFONT=${PN}.nfont.tar.bz2

DOCS="AUTHORS BUGS LICENSE NEWS README status.txt"
FONT_SUFFIX="ttf"
S="${WORKDIR}/${MY_P}"
FONT_S="${S}"

src_install ()
{
	font_src_install
	use gnustep && nfont_src_install
}