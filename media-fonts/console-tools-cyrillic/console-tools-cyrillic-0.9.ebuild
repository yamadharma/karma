# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/sys-apps/console-data/console-data-1999.08.29-r2.ebuild,v 1.8 2002/10/04 06:23:17 vapier Exp $

IUSE=""

S=${WORKDIR}/${P}
DESCRIPTION="Cyrillic data (fonts, keymaps) for the consoletools package"
SRC_URI="ftp://ftp.ice.ru/pub/fonts/linux/${P}.tar.gz"
HOMEPAGE="http://www.ice.ru/~vitus"
KEYWORDS="x86 ppc sparc sparc64"
SLOT="0"
LICENSE="GPL-2"

inherit kbd fonts

src_unpack ()
{
  unpack ${A}
  cd ${S}
  rm -f keymap/.*.swp
}

#src_compile() 
#{
#
#
#}

src_install() 
{

  cd ${S}
  
  fonts-install psf psf/*
  kbd-trans-install acm/*
  kbd-trans-install sfm/*  
  
  dodir /usr/lib/${PN}
  cp -R scripts ${D}/usr/lib/${PN}
  cp -R keymap ${D}/usr/lib/${PN}
  
  dodoc README* windows.txt
  
}


