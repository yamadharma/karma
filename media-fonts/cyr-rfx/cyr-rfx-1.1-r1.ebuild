# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2

inherit fonts

IUSE=""

S=${WORKDIR}/koi8-1
DESCRIPTION="CYRillic Raster Fonts for X"
HOMEPAGE="http://www.inp.nsk.su/~bolkhov/files/fonts/cyr-rfx/00index.en.html"
SRC_URI="ftp://ftp.inp.nsk.su/pub/BINP/X11/fonts/cyr-rfx/${PN}-koi8-1-${PV}.tgz"

LICENSE="AS IS"
SLOT="0"
KEYWORDS="x86 sparc sparc64 ppc"

src_install() 
{
    cd ${S}
    fonts-install pcf 75dpi/*.pcf
    fonts-install pcf misc/*.pcf
    cat 75dpi/fonts.alias misc/fonts.alias > ${D}/${PCF_FONTSDIR}/fonts.alias

    cd ${S}
    dodoc doc/*
}

