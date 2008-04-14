# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils 

DESCRIPTION="LightSquid - lite log analizer for squid proxy, inspirated by sarg."
HOMEPAGE="http://lightsquid.sf.net"
SRC_URI="mirror://sourceforge/${PN}/${P/_/-}.tgz"

S=${WORKDIR}/${P/_/-}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="media-libs/gd"
RDEPEND="${DEPEND}
	dev-perl/GD"

HTMLDIR=/var/www/localhost/htdocs

src_unpack () 
{
	unpack ${A}
	cd ${S}
	
	sed -i \
	-e "s:/var/www/html:$HTMLDIR:g" \
	lightsquid.cfg || die "setting default for gentoo directories... failed"
}

src_compile () 
{
	einfo "Nothing to compile"
}

src_install () 
{
	dodir /etc/cron.hourly
	echo -e "#!/bin/sh\n${HTMLDIR}/lightsquid/lightparser.pl today" > ${D}/etc/cron.hourly/lightsquid
	chmod +x ${D}/etc/cron.hourly/lightsquid

	dodir /etc/lightsquid
	mv *.cfg* ${D}/etc/lightsquid	

	dosym /etc/lightsquid/lightsquid.cfg ${HTMLDIR}/lightsquid/lightsquid.cfg
	dosym /etc/lightsquid/realname.cfg ${HTMLDIR}/lightsquid/realname.cfg
	dosym /etc/lightsquid/group.cfg ${HTMLDIR}/lightsquid/group.cfg
	dosym /etc/lightsquid/skipuser.cfg ${HTMLDIR}/lightsquid/skipuser.cfg
	
	dodoc doc/*
	rm -rf doc
	
	dodir ${HTMLDIR}/lightsquid
	cp -R ${S}/* ${D}/${HTMLDIR}/lightsquid
}


