# Copyright 1999-2005 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit perl-module

IUSE=""

DESCRIPTION="Rules for PCX-Firewall"
HOMEPAGE="http://pcxfirewall.sourceforge.net/"
SRC_URI="mirror://sourceforge/pcxfirewall/${P}.tar.gz
	mirror://sourceforge/pcxfirewall/libpcxfirewall-rules-perl-${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="x86"
SLOT="0"

S1=${WORKDIR}/libpcxfirewall-rules-perl-${PV}

DEPEND=">=dev-perl/libpcxfirewall-2.24
	>=dev-perl/XML-SAX-0.12
	>=dev-perl/XML-LibXML-1.58
	>=dev-perl/XML-LibXSLT-1.57"
	
RDEPEND="$DEPEND
	net-firewall/iptables"
	
src_compile () 
{
        cd ${S1}
	perl-module_src_compile
}

src_install () 
{

	cd ${S1}
	perl-module_src_install
	
	cd ${S}
	cp -R ${S}/usr ${D}
	
	dodoc README* INSTALL Changes firewall_rules.spec
	dohtml -r docs/*
}


