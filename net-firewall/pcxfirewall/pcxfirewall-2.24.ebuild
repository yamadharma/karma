# Copyright 1999-2005 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

IUSE=""

DESCRIPTION="Command line util for managing firewall rules"
HOMEPAGE="http://pcxfirewall.sourceforge.net/"
SRC_URI="mirror://sourceforge/pcxfirewall/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="x86 amd64"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
	>=dev-perl/libpcxfirewall-${PV}
	net-firewall/iptables"
	
src_install () 
{

	dodir /usr/lib/pcx-firewall
	cp -R ${S}/usr/lib/pcx-firewall/* ${D}/usr/lib/pcx-firewall
	
	exeinto /etc/pcx-firewall
	newexe dynamic_rules.sh dynamic_rules.sh.ex
	
	dodoc README* INSTALL firewall.spec
	dodoc docs/*.pm
	dohtml -r docs/*

	newinitd ${FILESDIR}/pcxfirewall.rc pcxfirewall
}


