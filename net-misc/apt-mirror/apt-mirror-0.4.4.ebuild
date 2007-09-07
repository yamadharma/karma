# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_P=${PN}_${PV}-2

DESCRIPTION="ECLiPt FTP mirroring tool"
HOMEPAGE="http://apt-mirror.sf.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ~ppc"
IUSE=""

src_unpack ()
{
	unpack ${A}
	epatch ${FILESDIR}/apt-mirror_0.4.4-5ubuntu1.diff.gz
}

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	exeinto /usr/bin
	doexe apt-mirror
	insinto /etc/apt
	doins mirror.list
	
	exeinto /etc/cron.daily
	newexe ${FILESDIR}/apt-mirror.cron apt-mirror
	
	keepdir /var/spool/apt-mirror/var 
	keepdir /var/spool/apt-mirror/skel
	keepdir /var/spool/apt-mirror/mirror
	
	pod2man apt-mirror > apt-mirror.1
	doman apt-mirror.1

}
