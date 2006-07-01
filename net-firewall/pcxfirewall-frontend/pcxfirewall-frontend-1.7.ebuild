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
	>=dev-perl/libpcxfirewall-2.24
	>=net-firewall/pcxfirewall-2.24
	>=net-firewall/pcxfirewall-rules-2.6
	dev-perl/Config-IniFiles
	>=dev-perl/HTML-Object-2.25"

src_install () 
{

	cp -R ${S}/etc ${D}

	dodir /usr/share/pcxfirewall
	cp -f index.html ${D}/usr/share/pcxfirewall/
	cp -Rf cgi-bin ${D}/usr/share/pcxfirewall/
	cp -Rf css ${D}/usr/share/pcxfirewall/
	cp -Rf js ${D}/usr/share/pcxfirewall/
	cp -Rf configs ${D}/usr/share/pcxfirewall/


# now fixup permissions
#chown ${WEBUSER}:${WEBGROUP} ${PREFIX}/usr/share/pcxfirewall/configs
#chmod 0700 ${PREFIX}/usr/share/pcxfirewall/configs
#chown -R ${WEBUSER}:${WEBGROUP} ${PREFIX}/usr/share/pcxfirewall/configs/*
#chmod 0600 ${PREFIX}/usr/share/pcxfirewall/configs/*.xml

#chown ${WEBUSER}:${WEBGROUP} ${PREFIX}/etc/pcx-firewall/frontend
#chmod 0700 ${PREFIX}/etc/pcx-firewall/frontend

}


