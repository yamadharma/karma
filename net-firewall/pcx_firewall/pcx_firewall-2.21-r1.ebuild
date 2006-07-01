# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit perl-module

IUSE=""

DESCRIPTION="Command line util for managing firewall rules"
SRC_URI="mirror://sourceforge/pcxfirewall/${P}.tar.gz"
HOMEPAGE="http://pcxfirewall.sourceforge.net/"
LICENSE="GPL-2"
KEYWORDS="x86"
SLOT="0"

S=${WORKDIR}/${P}

DEPEND=""
RDEPEND="${DEPEND}
	net-firewall/iptables"
	
src_compile () 
{

    cd ${S}
    tar xvzf pcx_firewall_perl-${PV}.tar.gz
    
    cd pcx_firewall_perl-${PV}
    perl Makefile.PL PREFIX=${D}/usr
    make

}

src_install () 
{

    cd pcx_firewall_perl-${PV}
    make \
	PREFIX=${D}/usr \
	INSTALLMAN1DIR=${D}/usr/share/man/man1 \
	INSTALLMAN2DIR=${D}/usr/share/man/man2 \
	INSTALLMAN3DIR=${D}/usr/share/man/man3 \
	INSTALLMAN4DIR=${D}/usr/share/man/man4 \
	INSTALLMAN5DIR=${D}/usr/share/man/man5 \
	INSTALLMAN6DIR=${D}/usr/share/man/man6 \
	INSTALLMAN7DIR=${D}/usr/share/man/man7 \
	INSTALLMAN8DIR=${D}/usr/share/man/man8 \
	install \
	|| die

    cd ${S}
    dodir /usr/lib/pcx_firewall
    cp -aRp usr/lib/pcx_firewall/* ${D}/usr/lib/pcx_firewall
  
    cd ${S}
    dodoc docs/*.pm
    dodoc README* INSTALL
    dohtml -r docs/*
    
    exeinto /etc/pcx_firewall
    doexe dynamic_rules.sh
    
    exeinto /etc/init.d 
    doexe ${FILESDIR}/rc.d/${PV}/pcx_firewall

}


