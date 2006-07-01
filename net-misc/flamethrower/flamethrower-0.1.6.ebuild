# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils perl-module

IUSE="${IUSE}"

DESCRIPTION="Flamethrower is intended to be an easy to use multicast file distribution system."
HOMEPAGE="http://www.systemimager.org/"
SRC_URI="mirror://sourceforge/systemimager/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64"

DEPEND="dev-lang/perl
	dev-perl/AppConfig"

RDEPEND="dev-lang/perl
	dev-perl/AppConfig
	net-misc/udpcast"


src_unpack () 
{
	unpack ${P}.tar.bz2

	cd ${S}
	epatch ${FILESDIR}/Makefile.PL.patch
}

src_install () 
{
	perl-module_src_install
	
	rm -rf ${D}/etc
	
	newinitd ${FILESDIR}/flamethrower-server.initd flamethrower-server

	dodir /etc/flamethrower
	insinto /etc/flamethrower
	doins ${S}/etc/flamethrower.conf	

}
