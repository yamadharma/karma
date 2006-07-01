# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/sys-devel/spython/spython-2.0-r9.ebuild,v 1.9 2002/10/23 19:40:23 vapier Exp $

IUSE="readline mysql postgres java gtk gtk2 perl truetype pdflib ssl"

S=${WORKDIR}/${P}
SLOT="7.2"
DESCRIPTION="Pike is a high-level, interpreted and modular object-oriented language"
SRC_URI="ftp://ftp.caudium.net/pike/${SLOT}/${P}.tar.gz"


HOMEPAGE="http://pike.ida.liu.se/"
LICENSE="GPL-2"
KEYWORDS="x86 sparc sparc64"


DEPEND=">=sys-devel/autoconf-2.13 
	>=sys-libs/zlib-1.1.4 
	readline? ( >=sys-libs/readline-4.1 >=sys-libs/ncurses-5.2 )
	dev-libs/gmp
	mysql? dev-db/mysql
	postgres? ( >=dev-db/postgresql-7 )
	ssl?	( dev-libs/openssl )
	dev-lang/perl
	java?	virtual/jdk
	media-libs/tiff
	media-libs/jpeg
	media-libs/giflib
	truetype?	( media-libs/freetype )
	media-libs/libpng
	gtk?	( x11-libs/gtk+-1.2* )
	gtk2?	( x11-libs/gtk+-2* )
	perl?	>=dev-lang/perl-5.8
	pdflib? ( >=media-libs/pdflib-4.0.1-r2 )
	dev-lang/nasm"

#RDEPEND="virtual/glibc"


src_unpack() 
{
  unpack ${A}
  
  cd ${S}/src
#  sed -e "s:^buildroot=$:buildroot=${D}:g" Makefile.in >  Makefile.in.tmp
#  mv -f Makefile.in.tmp Makefile.in

#  sed -e "s:^INSTALLARGS =.*$:INSTALLARGS = --traditional:g" Makefile.in >  Makefile.in.tmp
#  mv -f Makefile.in.tmp Makefile.in

}

src_compile() 
{
  
  local myconf
  local cppflags
  local include-path

  cppflags="-I/usr/include"

  if use postgres
  then
    myconf="${myconf} --with-postgres --with-postgres-include-dir=/usr/include/postgresql --with-libpq-dir=/usr/lib"
    cppflags="${cppflags} -I/usr/include/postgresql/server"
  fi

  if use truetype
  then
    myconf="${myconf} --with-freetype --with-ttflib"
    cppflags="${cppflags} -I/usr/include/freetype2"
#    include-path="${include-path} /usr/include/freetype2"
  fi

  if use truetype
  then
    myconf="${myconf} --with-sslay"
    cppflags="${cppflags} -I/usr/include/openssl"
  fi

  myconf="${myconf} `use_with mysql`"
  myconf="${myconf} `use_with perl`"  
  myconf="${myconf} `use_with gtk GTK`"
  myconf="${myconf} `use_with gtk2 GTK2`"
  myconf="${myconf} `use_with pdflib libpdf`"
  

#    export LDFLAGS=-static

  cd ${S}/src

  CPPFLAGS=${cppflags} \
  ./configure --prefix=/usr \
    --with-double-precision \
    --with-long-double-precision \
    --with-poll \
    --with-gmp \
    --with-bignums \
    --with-zlib \
    --with-max-fd=65000 \
    --with-security \
    --with-ssleay \
    --with-threads \
    --with-gdbm \
    ${myconf}

#    --with-include-path=${include-path} \

#  sed -e "s:^buildroot=$:buildroot=${D}:g" Makefile >  Makefile.tmp
#  mv -f Makefile.tmp Makefile
 
  cd ${S}/src
  make 


}

src_install () 
{
  cd ${S}

  make \
    -Csrc/ \
    buildroot=${D} \
    prefix=/usr \
    INSTALLARGS="--traditional" \
    install

#    prefix=/usr \
#    INSTALLARGS="--traditional" \
#    share_prefix=/usr/lib/pike/$(PV) \
#    lib_prefix=/usr/lib/pike/$(PV) \

  
#  dodir /usr/bin
#  rm -rf ${D}/opt/bin
#  dosym /opt/pike/${PV}/bin/pike /usr/bin/pike
  
#  cd ${D}/opt/pike/${PV}/include/pike
#  chmod -x *

  cd ${D}/usr/include/pike
  chmod -x *
  
#  rm -rf ${D}/opt/pike/${PV}/man
#  cd ${S}/man
#  doman *.1
  
}

#pkg_preinst() {
#
#}
