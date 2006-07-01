# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /home/cvsroot/gentoo-x86/net-misc/cfengine/cfengine-2.0.3.ebuild,v 1.5 2002/07/06 14:39:35 phoenix Exp $

S=${WORKDIR}/${PN}
DESCRIPTION="VLAN configuration tool"
SRC_URI="http://www.candelatech.com/~greear/vlan/${PN}.${PV}.tar.gz"
HOMEPAGE="http://www.candelatech.com/~greear/vlan"

#DEPEND=""
#RDEPEND="${DEPEND}"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

src_compile() {
	local myconf
	emake || die
}

src_install () {
	mkdir -p ${D}/usr/bin
	cp vconfig ${D}/usr/bin
	doman vconfig.8
	dodoc README CHANGELOG vlan_test.pl vlan_test2.pl
	dohtml vlan.html howto.html
}

