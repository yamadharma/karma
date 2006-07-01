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
  
  dodir /usr/share/fonts/pcf/${PN}/koi8-1
  
  cd ${S}
  cp -R 75dpi misc ${D}/usr/share/fonts/pcf/${PN}/koi8-1

  cd ${D}/usr/share/fonts/pcf/${PN}/koi8-1/75dpi
  gzip *.pcf
  mkfontdir

  cd ${D}/usr/share/fonts/pcf/${PN}/koi8-1/misc
  gzip *.pcf
  mkfontdir

    
  cd ${S}
  dodoc doc/*
}

pkg_postinst() 
{
  cd /usr/share/fonts/pcf/${PN}/koi8-1/75dpi
  mkfontdir

  cd /usr/share/fonts/pcf/${PN}/koi8-1/misc
  mkfontdir
}

#pkg_postrm() 
#{
#}
