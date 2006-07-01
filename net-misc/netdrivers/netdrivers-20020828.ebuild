# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2

DESCRIPTION="Network device driver updates for Linux"
HOMEPAGE="http://www.scyld.com/network/index.html"
LICENSE="GPL-2"
DEPEND="virtual/linux-sources"

SRC_URI="ftp://ftp.scyld.com/pub/network/${PN}.tgz"
S="${WORKDIR}"
SLOT="0"
KEYWORDS="x86 ppc sparc sparc64"

src_compile() {
	check_KV
	cd ${S}
	emake
}

src_install () {
	make PREFIX=${D} install
#	insinto "/lib/modules/${KV}/kernel/drivers/net"
#	doins ${S}/src/e100.o
#	doman e100.7
#	dodoc LICENSE README SUMS e100.spec ldistrib.txt
}

pkg_postinst() {
	/sbin/depmod -a
}
