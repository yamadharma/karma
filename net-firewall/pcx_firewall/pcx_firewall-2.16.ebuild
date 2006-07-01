# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2

DESCRIPTION="Command line util for managing firewall rules"
SRC_URI="mirror://sourceforge/pcxfirewall/${P}.tar.gz"
HOMEPAGE="http://pcxfirewall.sourceforge.net/"
LICENSE="GPL-2"
KEYWORDS="x86"
SLOT="0"
DEPEND=">=dev-lang/perl-5.6*
	net-firewall/iptables"
RDEPEND="dev-lang/perl"
S=${WORKDIR}/${P}

src_install () {
	dodir /usr
	./install -p ${D}
	rm -rf ${D}/etc/rc.d
	
	exeinto /etc/init.d ; newexe ${FILESDIR}/rc.d/pcx_firewall.rc pcx_firewall
#	insinto /etc/conf.d ; newins ${FILESDIR}/rc.d/pcx_firewall.confd pcx_firewall
}

#pkg_postinst() {
#}
