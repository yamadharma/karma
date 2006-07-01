# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

FONT_SUPPLIER="urw"
FONT_BUNDLE="base35"

inherit fonts

IUSE="${IUSE}"

MY_PN=urw-fonts

MY_PV=${PV/_/}
MY_P=${MY_PN}-${MY_PV}

DESCRIPTION="Cyrillized free URW fonts"
SRC_URI="ftp://ftp.gnome.ru/fonts/urw/release/${MY_P}.tar.bz2"
HOMEPAGE=""
KEYWORDS="x86 ~ppc"
LICENSE="GPL-2,LGPL"
SLOT="0"

S="${WORKDIR}"

FONT_FORMAT="type1"

mydoc="COPYING ChangeLog README README.tweaks TODO"

src_install ()
{
    fonts_src_install
    
    cp fonts.dir fonts.scale ${D}${TYPE1_FONTSDIR}
}

# Local Variables:
# mode: sh
# End:
