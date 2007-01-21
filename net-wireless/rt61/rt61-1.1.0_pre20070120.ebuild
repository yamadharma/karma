# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/rt61/rt61-1.1.0_beta1.ebuild,v 1.3 2006/12/01 19:05:20 genstef Exp $

ECVS_CVS_COMMAND="cvs -q"
ECVS_SERVER="rt2400.cvs.sourceforge.net:/cvsroot/rt2400"
ECVS_USER="anonymous"
ECVS_AUTH="pserver"
ECVS_MODULE="source/${PN}"
ECVS_CO_OPTS="-P -D ${PV/*_pre}"
ECVS_UP_OPTS="-dP -D ${PV/*_pre}"
ECVS_TOP_DIR="${DISTDIR}/cvs-src/sourceforge.net/rt2400"

S=${WORKDIR}/${ECVS_MODULE}

inherit linux-mod cvs

DESCRIPTION="Driver for the RaLink RT61 wireless chipsets"
HOMEPAGE="http://rt2x00.serialmonkey.com/wiki/index.php/Main_Page"
LICENSE="GPL-2"

#MY_P=${P/_beta/-b}

#SRC_URI="mirror://sourceforge/rt2400/${MY_P}.tar.gz"

KEYWORDS="-* amd64 x86"
IUSE="debug"
DEPEND=""
RDEPEND="net-wireless/wireless-tools
	!net-wireless/ralink-rt61"
S="${WORKDIR}/${MY_P}"
MODULE_NAMES="rt61(net:${S}/Module)"

CONFIG_CHECK="NET_RADIO"
ERROR_NET_RADIO="${P} requires support for Wireless LAN drivers (non-hamradio) & Wireless Extensions (CONFIG_NET_RADIO)."

MODULESD_RT61_ALIASES=('ra? rt61')

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_PARAMS="KERNDIR=${KV_DIR} KERNOUT=${KV_OUT_DIR}"
}

src_compile() {
	use debug && BUILD_TARGETS="clean debug"
	linux-mod_src_compile
}

src_install() {
	linux-mod_src_install
	dodoc BIG_FAT_WARNING CHANGELOG FAQ TESTING THANKS
	dodoc Module/README Module/STA_iwpriv_ATE_usage.txt
	insinto /etc/Wireless/RT61STA
	doins Module/rt{2{561{,s},661}.bin,61sta.dat}
}

pkg_postinst() {
	linux-mod_pkg_postinst

	einfo
	einfo "Thanks to RaLink for releasing open drivers!"
	einfo
}
