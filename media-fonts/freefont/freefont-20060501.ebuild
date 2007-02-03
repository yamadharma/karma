# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $


inherit font nfont

IUSE="X gnustep"

SUB_PV=cvs
PATCH_V=-10

DESCRIPTION="Free UCS Outline Fonts"
SRC_URI="mirror://debian/pool/main/t/ttf-${PN}/ttf-${PN}_${PV}${SUB_PV}.orig.tar.gz
	mirror://debian/pool/main/t/ttf-${PN}/ttf-${PN}_${PV}${SUB_PV}${PATCH_V}.diff.gz"
	
HOMEPAGE="http://www.nongnu.org/freefont/
	http://alioth.debian.org/projects/freefont"
LICENSE="GPL-2"

SLOT="0"

KEYWORDS="x86 amd64 ~sparc ~ppc"

S=${WORKDIR}/ttf-${PN}-${PV}${SUB_PV}

DEPENDS="media-gfx/pfaedit"

FONT_BUNDLE=freefont

FONT_FORMAT="ttf"
FONT_SUFFIX="ttf"

FONT_S="${S}/TTF"

DOCS="AUTHORS COPYING CREDITS ChangeLog INSTALL README"

src_unpack ()
{
	unpack ${A}
	cd ${S}
	patch -p1 < ${WORKDIR}/ttf-${PN}_${PV}${SUB_PV}${PATCH_V}.diff
	
	cd ${S}
	while read i 
	do 
	    epatch debian/patches/$i || die
	done < debian/patches/series
	
	cd ${S}/debian/scripts
	chmod +x *
}

src_compile ()
{
	./debian/scripts/convertfonts.sh || die
}

src_install ()
{
	font_src_install
	use gnustep && nfont_src_install
}


# Local Variables:
# mode: sh
# End:
