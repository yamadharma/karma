# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit patch

IUSE="${IUSE}"


S=${WORKDIR}/${P}
DESCRIPTION="Small perl script which generates the fonts.scale file to use any Type 1 PostScript fonts"
HOMEPAGE="ftp://sunsite.unc.edu/pub/Linux/X11/xutils/"
SRC_URI="ftp://sunsite.unc.edu/pub/Linux/X11/xutils/${P}.tar.gz"

LICENSE="GPL"
SLOT="0"
KEYWORDS="x86 sparc sparc64 ppc"

DEPEND="dev-lang/perl"
	
RDEPEND="${DEPEND}"


#src_compile () 
#{
#    emake || die
#}

src_install () 
{
    cd ${S}
    dobin t1embed type1inst
    
    mv type1inst.man type1inst.1
    doman type1inst.1
    
    dodoc COPYING ChangeLog README type1inst-0.6.1.lsm
}

