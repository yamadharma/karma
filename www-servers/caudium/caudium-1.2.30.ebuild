# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/net-www/apache/apache-2.0.44.ebuild,v 1.5 2003/02/23 19:39:22 woodchip Exp $

IUSE="perl"

inherit extrafiles

DESCRIPTION="Caudium Web Server"
HOMEPAGE="http://www.caudium.net/"

CVS_REV=""

MY_P=${P}${CVS_REV}

S="${WORKDIR}/${MY_P}"
SRC_URI="ftp://ftp.caudium.net/caudium/source/${MY_P}.tar.bz2"

LICENSE="GPL-2 | LGPL-2.1 | MPL-1.1"
SLOT="0"
KEYWORDS="x86 ppc alpha hppa"

DEPEND="( >=dev-lang/pike-7.0.268
	<dev-lang/pike-7.4 )
	perl?	>=dev-lang/perl-5.8
	dev-libs/expat
	app-text/sablotron
	dev-libs/openssl"
	
	
#dev-util/yacc
#	sys-libs/db
#	dev-lang/perl
#	>=sys-libs/zlib-1.1.4
#	>=sys-libs/gdbm-1.8
#	>=dev-libs/expat-1.95.2
#	>=dev-libs/openssl-0.9.6e"
#	ldap? =net-nds/openldap-2*
#IUSE="ldap"


#src_unpack() 
#{
#}

src_compile() 
{
    local myconf
    
    cd ${S}
    
    econf \
	${myconf}
    
    emake || die "Compile error"
  
}

src_install () 
{
    make install_alt prefix=/usr DESTDIR=${D} 
    
    mv ${D}/usr/share/doc/caudium ${D}/usr/share/doc/${P}
    
    extrafiles_install
    
    dodir /var/lib/caudium
    dodir /var/run/caudium  
    dodir /var/log/caudium  
    dodir /var/cache/caudium/argument_cache  
}


pkg_config ()
{
    cd /usr/lib/caudium
    ./install \
	--log-directory=/var/log/caudium \
	--config-dir=/etc/caudium/servers \
	--pid-file=/var/run/caudium/caudium.pid \
	--var-directory=/var/cache/caudium && \
	sed -i -e "s:/tmp/caudium.pid:/var/run/caudium/caudium.pid:" /etc/caudium/servers/Global_Variables && \
	sed -i -e "s:../argument_cache:/var/cache/caudium/argument_cache:" /etc/caudium/servers/Global_Variables
}

# Local Variables:
# mode: sh
# End:


