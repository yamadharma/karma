# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="LightSquid - lite log analizer for squid proxy, inspirated by sarg."
HOMEPAGE="http://lightsquid.sf.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="media-libs/gd"
RDEPEND="${DEPEND}
	>=www-proxy/squid-2.5.1"

HTMLDIR=/srv/localhost/www/lightsquid

src_unpack () 
{
	unpack ${A}
	cd ${S}
	
	sed -i \
	-e 's:"/var/www/html/lightsquid/report":"${HTMLDIR}/report":' \
	lightsquid.cfg || die "setting default for gentoo directories... failed"
}

src_compile () 
{
	einfo "Nothing to compile"
}

src_install () 
{
	dodir ${HTMLDIR}
	cp -R ${S}/* ${D}/${HTMLDIR}
	
	dodir /etc/cron.hourly
	echo -e "#!/bin/sh\n${HTMLDIR}/lightparser.pl today" > ${D}/etc/cron.hourly/lightsquid
	chmod +x ${D}/etc/cron.hourly/lightsquid
}

