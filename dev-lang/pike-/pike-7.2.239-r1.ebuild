# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/sys-devel/spython/spython-2.0-r9.ebuild,v 1.9 2002/10/23 19:40:23 vapier Exp $

IUSE="readline mysql postgres java gtk gtk2"

#S=${WORKDIR}/${P}
S=${WORKDIR}/Pike-v${PV}
SLOT="7.2"
DESCRIPTION="Pike is a high-level, interpreted and modular object-oriented language"
SRC_URI="ftp://ftp.caudium.net/pike/official_releases/${PV}/${P}.tar.gz"

HOMEPAGE="http://pike.ida.liu.se/"
LICENSE="GPL-2"
KEYWORDS="x86 sparc sparc64"


DEPEND=">=sys-devel/autoconf-2.13 
	>=sys-libs/zlib-1.1.4 
	readline? ( >=sys-libs/readline-4.1 >=sys-libs/ncurses-5.2 )
	dev-libs/gmp
	mysql? dev-db/mysql
	postgres? ( >=dev-db/postgresql-7 )
	dev-lang/perl
	java?	virtual/jdk
	media-libs/tiff
	media-libs/jpeg
	media-libs/giflib
	media-libs/freetype
	media-libs/libpng
	gtk?	( x11-libs/gtk+-1.2* )
	gtk2?	( x11-libs/gtk+-2* )"

#RDEPEND="virtual/glibc"

# spython can't provide python anymore, since it is missing important services like crypt.
# upgrades from spython to python can cause things like mailman's authentication system to break.
#PROVIDE="virtual/python"
# This means we also need to remove the /usr/bin/python symlink.

#src_unpack() {
#
#
#}

src_compile() 
{
  
  local myconf
  myconf="${myconf} `use_with postgres`"
  myconf="${myconf} `use_with mysql`"
  myconf="${myconf} `use_with gtk GTK`"
  myconf="${myconf} `use_with gtk2 GTK2`"
  

#    export LDFLAGS=-static

  cd ${S}/src
  
  ./configure --prefix=/usr \
    --with-double-precision \
    --with-long-double-precision \
    --with-perl \
    --with-poll \
    --with-gmp \
    --with-security \
    --with-ssleay \
    ${myconf}

#  sed -e "s:^buildroot=$:buildroot=${D}:g" Makefile >  Makefile.tmp
#  mv -f Makefile.tmp Makefile
 
  cd ${S}/src
  make 


}

src_install () 
{
  cd ${S}/src
  make \
    buildroot=${D} \
    INSTALLARGS=--traditional \
    prefix=/usr \
    share_prefix=/usr/lib/pike/$(PV) \
    lib_prefix=/usr/lib/pike/$(PV) \
    install
  
#  dodir /usr/bin
#  rm -rf ${D}/usr/bin
#  dosym /usr/lib/pike/$(PV)/bin/pike /usr/bin/pike
  
  cd ${D}/usr/include/pike
  chmod -x *
}

#pkg_preinst() {
#
#}
