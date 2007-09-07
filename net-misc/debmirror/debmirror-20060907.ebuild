# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P=${PN}_${PV}.1

DESCRIPTION="ECLiPt FTP mirroring tool"
HOMEPAGE="http://apt-mirror.sf.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ~ppc"
IUSE=""

S=${WORKDIR}/${PN}-20060908

DEPEND=""
RDEPEND="net-misc/rsync
	app-arch/bzip2
	dev-perl/Digest-SHA1
	dev-perl/LockFile-Simple
	dev-perl/Compress-Zlib
	dev-perl/libwww-perl"

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
#	exeinto /usr/bin
	dobin debmirror
	insinto /etc
	doins debmirror.conf
	
#	exeinto /etc/cron.daily
#	newexe ${FILESDIR}/apt-mirror.cron apt-mirror
	
#	keepdir /var/spool/apt-mirror/var 
#	keepdir /var/spool/apt-mirror/skel
#	keepdir /var/spool/apt-mirror/mirror
	
	pod2man debmirror > debmirror.1
	doman debmirror.1
	
	dodoc ${S}/doc/*
}
