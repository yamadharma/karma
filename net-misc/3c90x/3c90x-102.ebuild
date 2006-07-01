# Copyright 2002 Arcady Genkin <agenkin@thpoon.com>
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/net-misc/e1000/e1000-4.3.15.ebuild,v 1.1 2002/09/23 13:40:19 agenkin Exp $

DESCRIPTION="Kernel driver for 3Com 3x905 ethernet adapters"
HOMEPAGE="http://support.3com.com/infodeli/tools/nic/linuxdownloads.htm"
LICENSE="GPL-2"
DEPEND="virtual/linux-sources"
RDEPEND="${DEPEND}"

SRC_URI="http://support.3com.com/infodeli/tools/nic/linux/${P}.tar.gz"

SLOT="0"
KEYWORDS="x86"
S="${WORKDIR}/${P}"

src_unpack() {
	unpack ${A}

	cd ${WORKDIR}/${P}
	patch -p0 < ${FILESDIR}/patch/patch.102.vlan || die

}

src_compile() {
	check_KV
	
	cd "${S}"
	
	./compile_UP
}

src_install () {
	insinto "/lib/modules/${KV}/kernel/drivers/net"
	doins "${S}/3c90x.o"
	dodoc readme
}

pkg_postinst() {
	/sbin/depmod -a
}
