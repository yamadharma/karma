# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/net-www/apache/apache-2.0.44.ebuild,v 1.5 2003/02/23 19:39:22 woodchip Exp $

inherit eutils

DESCRIPTION="CAMAS or CAudium Mail Access System, a webmail for the Caudium webserver"
HOMEPAGE="http://www.caudium.net/"

IUSE="doc"

MY_P=${PN}-${PV/_pre*}-${PV/*_pre}-cvs

S="${WORKDIR}/${MY_P}"
SRC_URI="ftp://ftp.caudium.net/caudium/camas/${MY_P}.tar.bz2"

LICENSE="GPL-2 | LGPL-2.1 | MPL-1.1"
SLOT="0"
KEYWORDS="x86 amd64"

DEPEND="www-servers/caudium"
	
	

src_compile() 
{
    local myconf
    myconf="${myconf} --with-caudium=/usr/lib/caudium"    

    cd ${S}
    
    econf \
	${myconf}
    
    emake || die "Compile error"
  
}

src_install () 
{
    make install prefix=/usr DESTDIR=${D} 
    
    dodir /usr/share/doc/${P}
    use doc && cp -R ${S}/docs/* ${D}/usr/share/doc/${P}
}



# Local Variables:
# mode: sh
# End:


