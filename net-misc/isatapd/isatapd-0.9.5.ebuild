# Distributed under the terms of the GNU General Public License v2

DESCRIPTION="ISATAP client for Linux"
HOMEPAGE="http://www.saschahlusiak.de/linux/isatap.htm"
SRC_URI="http://www.saschahlusiak.de/linux/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

src_install() {
	newinitd openrc/isatapd.init.d isatapd
	newconfd openrc/isatapd.conf.d isatapd
	
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc README ChangeLog AUTHORS
}

pkg_postinst() {
	elog "To add support for a ISATAP connection at startup," 
	elog "remember to run:"
	elog "# rc-update add isatapd default" 
}
