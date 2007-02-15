# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/sys-devel/spython/spython-2.0-r9.ebuild,v 1.9 2002/10/23 19:40:23 vapier Exp $

IUSE="readline mysql postgres java"

S=${WORKDIR}/${P}
SLOT="7.2"
DESCRIPTION="Pike is a high-level, interpreted and modular object-oriented language"
SRC_URI="ftp://ftp.caudium.net/pike/${SLOT}/${P}.tar.gz"

HOMEPAGE="http://pike.ida.liu.se/"
LICENSE="GPL-2"
KEYWORDS="~x86 sparc sparc64"


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
	media-libs/libpng"

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

#    export LDFLAGS=-static

  cd ${S}/src

  econf --prefix=/usr \
    --with-double-precision \
    --with-long-double-precision \
    --with-perl \
    --with-poll \
    --with-gmp \
    --with-security \
    --with-ssleay \
    ${myconf}
  
 
  cd ${S}/src
  emake


}

src_install() {
  make install prefix=${D}
#    dodir /usr/share/man
#    make install prefix=${D}/usr MANDIR=${D}/usr/share/man || die

#	rm -rf ${D}/usr/include
#	rm -rf ${D}/usr/lib/${PN}${PV}/config
	
#	dodir /usr/lib/python${PV}/site-packages
#	rm -rf ${D}/usr/lib/spython${PV}/site-packages
#	dosym ../python${PV}/site-packages /usr/lib/spython${PV}/site-packages
	
#    if [ "`use build`" ]
#    then
#        rm -rf ${D}/usr/share/man
#		rm -rf ${D}/usr/include
#    	cd ${D}/usr/lib/spython2.0
#		#remove test and lib-tk directory; we can do much more cleaning too.
#		rm -rf test lib-tk
#		#clean out byte-compiled stuff.  They aren't required, and doing so saves space 
#		#cd to root so "find" works properly.
#		cd ${D}
#		local x
#		for x in `find -iname '*.py[co]'`
#		do
#			rm x
#		done
#	fi
}

#pkg_preinst() {
#
#}
