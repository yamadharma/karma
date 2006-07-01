# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2

DESCRIPTION="Rules for PCX-Firewall"
SRC_URI="mirror://sourceforge/pcxfirewall/${P}.tar.gz"
HOMEPAGE="http://pcxfirewall.sourceforge.net/"
LICENSE="GPL-2"
KEYWORDS="x86"
SLOT="0"
DEPEND=">=dev-lang/perl-5.6*
	>=net-misc/pcx_firewall-2.15
	>=dev-libs/libxml2-2.4.11
	>=dev-perl/XML-SAX-0.10
	>=dev-perl/XML-LibXML-1.40
	net-firewall/iptables"
RDEPEND="dev-lang/perl"
S=${WORKDIR}/${P}

src_install () {
	dodir /usr
	./install -p ${D}
#	rm -rf ${D}/usr/etc/rc.d
}

#pkg_postinst() {
#}
