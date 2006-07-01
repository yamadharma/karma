# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="This system for count and control traffic in your ip net"
HOMEPAGE="http://www.netams.com/"
SRC_URI="ftp://belial.org.ru/gentoo/netams/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=net-libs/libpcap-0.8.3-r1
        >=dev-db/mysql-4.0.24-r1
        >=net-firewall/iptables-1.3.1-r4
	>=net-www/apache-2.0.54-r6"

src_compile() {
    emake || die "emake failed"
}

src_install() {
    insinto /usr/sbin
    insopts -m755
    doins src/netams src/netamsctl src/flowprobe src/ipfw2netflow src/ulog2netflow
    doman doc/netams.8 doc/netamsctl.8 doc/flowprobe.8
    dodoc doc/README doc/TODO.txt INSTALL Copyright
    # install config
    insopts -m644
    insinto /etc
    doins NEW/netams.cfg addon/.netamsctl.rc
    # install startup script
    insopts -m755
    insinto /etc/init.d
    doins NEW/netams
}

pkg_postinst() {
    # make warning
    echo
    ewarn "Dear friend! Congratulation! Netans have been installed."
    ewarn "Don't forget make changes in /etc/netams.cfg file to your system."
    ewarn "And also you have to set up /etc/.netamsctl.rc."
    ewarn "For more information go to official documentation on http://www.netams.com/doc/index.html"
    echo
}