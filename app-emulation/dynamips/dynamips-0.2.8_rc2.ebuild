# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild come from http://code.gns3.net/hgwebdir.cgi/gns3-overlay/summary

inherit eutils flag-o-matic

MY_P="${P/_rc/-RC}"

DESCRIPTION="Cisco 7200/3600 Simulator"
HOMEPAGE="http://www.ipflow.utc.fr/index.php/Cisco_7200_Simulator"
SRC_URI="http://www.ipflow.utc.fr/dynamips/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT=0
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="net-libs/libpcap"
DEPEND="${RDEPEND}
	|| ( dev-libs/libelf dev-libs/elfutils )"

QA_EXECSTACK="usr/bin/dynamips"

S="${WORKDIR}/${MY_P}"

src_compile() {
	DYNAMIPS_ARCH="${ARCH}" emake -j1 || die "emake ${P} failed"
}

src_install () {
	dobin nvram_export dynamips || die "dobin failed"
	doman dynamips.1 hypervisor_mode.7 nvram_export.1
	dodoc COPYING ChangeLog TODO README README.hypervisor
}

pkg_postinst() {
	einfo "Please obtain IOS from Cisco website"
}
