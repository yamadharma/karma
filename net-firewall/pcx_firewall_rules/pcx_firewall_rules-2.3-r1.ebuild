# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit perl-module

IUSE=""

DESCRIPTION="Rules for PCX-Firewall"
SRC_URI="mirror://sourceforge/pcxfirewall/${P}.tar.gz"
HOMEPAGE="http://pcxfirewall.sourceforge.net/"
LICENSE="GPL-2"
KEYWORDS="x86"
SLOT="0"

S=${WORKDIR}/${P}

DEPEND=">=net-firewall/pcx_firewall-2.17
	>=dev-libs/libxml2-2.4.11
	>=dev-perl/XML-SAX-0.10
	>=dev-perl/XML-LibXML-1.40"
	
RDEPEND="$DEPEND
	net-firewall/iptables"

src_compile () 
{

    cd ${S}
    tar xvzf ${PN}_perl-${PV}.tar.gz
    cd ${PN}_perl-${PV}
    perl Makefile.PL \
	PREFIX=${D}/usr
    emake

}

src_install () 
{
  
    emake install

    cd ${S}
    dodir /usr/lib/pcx_firewall
    cp -aRp usr/* ${D}/usr
  
    cd ${S}
    dohtml docs/*
    dodoc README Changes convert.pl convert2.pl

}

