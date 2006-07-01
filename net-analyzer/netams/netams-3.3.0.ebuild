# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_P=${P/_/.}
S=${WORKDIR}/${P%%_rc*}


DESCRIPTION="This system for count and control traffic in your ip net"
HOMEPAGE="http://www.netams.com/"
SRC_URI="mirror://sourceforge/netams/${MY_P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=">=net-libs/libpcap-0.8.3-r1
        >=dev-db/mysql-4*
        net-firewall/iptables"

# net-www/webapp-config
# >=dev-db/mysql-4.0.24-r1
# >=net-firewall/iptables-1.3.1-r4


RDEPEND=">=net-libs/libpcap-0.8.3-r1
        >=dev-db/mysql-4*
        net-firewall/iptables"

	

src_compile () 
{
    make || die "emake failed"
}

src_install () 
{
#    webapp_src_preinst
    
    insinto /usr/sbin
    insopts -m755
    doins src/netams src/netamsctl src/flowprobe src/ipfw2netflow src/ulog2netflow

    doman doc/netams.8 doc/netamsctl.8 doc/flowprobe.8
    dodoc doc/README doc/TODO.txt INSTALL Copyright

    cp -R addon ${D}/usr/share/doc/${PF}
    
    # install config
    insopts -m644
    insinto /etc
    doins addon/netams.cfg addon/.netamsctl.rc

    # install startup script
    newinitd addon/netams-gentoo.sh netams

    dodir /srv/localhost/www/netams
    cp -r cgi-bin/* ${D}/srv/localhost/www/netams
    
#    dodir ${MY_CGIBINDIR}
#    cp -r cgi-bin/* ${D}/${MY_CGIBINDIR}/
#    webapp_serverowned ${MY_CGIBINDIR}
    
#    webapp_src_install
}

pkg_postinst () 
{
    # make warning
    echo
    ewarn "Dear friend! Congratulation! Netans have been installed."
    ewarn "Don't forget make changes in /etc/netams.cfg file to your system."
    ewarn "And also you have to set up /etc/.netamsctl.rc."
    ewarn "For more information go to official documentation on http://www.netams.com/doc/index.html"
    echo
}