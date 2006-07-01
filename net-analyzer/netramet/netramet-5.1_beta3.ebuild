# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/flow-tools/flow-tools-0.66.ebuild,v 1.4 2004/07/01 19:45:09 squinky86 Exp $

MY_PV=${PV/./}
MY_PV=${MY_PV/_beta/b}
MY_P=NeTraMet${MY_PV}

DESCRIPTION="NeTraMet is a network accounting meter."
HOMEPAGE="http://www2.auckland.ac.nz/net/NeTraMet/"
SRC_URI="ftp://ftp.auckland.ac.nz/pub/iawg/NeTraMet/beta-versions/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

S=${WORKDIR}/${MY_P}

IUSE="X ipv6"

DEPEND="virtual/libc
	net-libs/libpcap
	sys-libs/zlib
	X? ( virtual/x11
	    x11-libs/openmotif )"

src_compile () 
{
    econf \
	|| die "configure error"
	
    if ( use ipv6 )
	then
	sed -i -e "s:\(.*\)V6.*:\1V6 1:" ntm_conf.h
    fi
	
    emake || die "compilation error"
}

src_install () 
{
    einstall prefix=${D}/usr
    
    dodoc INSTALL README ntm-faq.txt
    
    cd ${D}/usr/share/mibs
    chmod -x *
    
    mv ${D}/usr/share/examples ${D}/usr/share/doc/${PF}
    
    cd ${S}
    cp -R pc ${D}/usr/share/doc/${PF}
    cp -R doc/* ${D}/usr/share/doc/${PF}
}
