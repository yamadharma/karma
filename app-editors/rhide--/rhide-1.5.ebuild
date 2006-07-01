# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/app-editors/scite/scite-1.5.1.ebuild,v 1.1 2003/02/27 04:01:03 mkennedy Exp $

S=${WORKDIR}/${P}
#SETEDIT_PV=0.5.2.RC1
SETEDIT_PV=0.4.57
#SETEDIT_PV=0.4.57
SETEDIT_S=${WORKDIR}/setedit
GDB_PV=5.3

DESCRIPTION="A very powerful editor for programmers"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
http://mirrors.rcn.net/pub/sourceware/gdb/releases/gdb-${GDB_PV}.tar.bz2
mirror://sourceforge/setedit/setedit-${SETEDIT_PV}.tar.gz"
#mirror://sourceforge/setedit/setedit-${SETEDIT_PV}-4.src.rpm" ## broken setedit-0.5.0.tar.gz on ibiblio
#mirror://sourceforge/setedit/setedit-${SETEDIT_PV}-4.src.rpm" ## broken setedit-0.5.0.tar.gz on ibiblio
#mirror://sourceforge/setedit/setedit-${SETEDIT_PV}.tar.gz" 

HOMEPAGE="http://www.rhide.com"

DEPEND="virtual/glibc
	sys-libs/rhtvision
	sys-devel/gdb
	dev-libs/libpcre"

#RDEPEND=""

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

#src_unpack()
#{
#    unpack ${A}
#}

#src_unpack()
#{
##    unpack ${A}
#    
#    unpack ${P}.tar.gz 
#    unpack gdb-${GDB_PV}.tar.bz2
#    cd ${WORKDIR}
#
#    rpm2targz ${DISTDIR}/setedit-${SETEDIT_PV}-4.src.rpm
#    tar zxf setedit-${SETEDIT_PV}-4.src.tar.gz
#    tar jxf setedit-${SETEDIT_PV}.tar.bz2
#    rm setedit*
#    ln -s setedit-${SETEDIT_PV} setedit
#
##    unpack setedit-${SETEDIT_PV}.tar.gz
#    
#}

src_compile() 
{
	local myconf

	cd ${SETEDIT_S}
	
	rm -f Makefile
	perl config.pl --libset
	make

#	./configure \
#	    --libset \
#	    ${myconf} || die
#
	make needed || die
	make libset || die	

	cd ${S}
	econf \
	    ${myconf} || die
	
	make || die

#	RHIDESRC=`pwd`
#	emake || die
}

src_install () 
{
	emake install prefix=${D}/usr || die
}

