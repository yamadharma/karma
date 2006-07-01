# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/sys-devel/spython/spython-2.0-r9.ebuild,v 1.9 2002/10/23 19:40:23 vapier Exp $

IUSE="readline build"

S=${WORKDIR}/Pike-v${PV}/src

DESCRIPTION="Pike is a high-level, interpreted and modular object-oriented language"
SRC_URI="ftp://pike.ida.liu.se/pub/pike/all/${PV}/Pike-v${PV}.tar.gz"

HOMEPAGE="http://www.python.org http://www.azstarnet.com/~donut/programs/fchksum/"
LICENSE="GPL-2"
KEYWORDS="~x86 sparc sparc64"
SLOT="7.4"

DEPEND=">=sys-devel/autoconf-2.13 
	>=sys-libs/zlib-1.1.4 
	readline? ( >=sys-libs/readline-4.1 >=sys-libs/ncurses-5.2 )
	dev-libs/gmp
	mysql? dev-db/mysql
	postgres? ( >=dev-db/postgresql-7 )"

RDEPEND="virtual/glibc"

# spython can't provide python anymore, since it is missing important services like crypt.
# upgrades from spython to python can cause things like mailman's authentication system to break.
#PROVIDE="virtual/python"
# This means we also need to remove the /usr/bin/python symlink.

#src_unpack() {
#
#
#}

src_compile() {
  local myconf
  use postgres && myconf="${myconf} --with-postgres"

#    export LDFLAGS=-static

  ./configure --prefix=/usr \
    --with-double-precision \
    --with-long-double-precision \
    --with-perl \
    --with-poll \
    --with-security \
    --with-ssleay \
    ${myconf}
  
    make

    #libdb3 support is available from http://pybsddb.sourceforge.net/; the one
    #included with python is for db 1.85 only.

#    cp Makefile Makefile.orig
#    sed -e "s/-g -O2/${CFLAGS}/" Makefile.orig > Makefile
#    cd ${S}/Modules
#    cp Makefile.pre Makefile.orig
#    sed -e "s:MODOBJS=:MODOBJS=fchksum.o md5_2.o:" \
#    Makefile.orig > Makefile.pre

    # Parallel make does not work
#    cd ${S}
#    try make

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
