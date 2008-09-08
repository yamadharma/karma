# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/btnx/btnx-0.4.8.ebuild $ 

# btnx-VER -> normal btnx release

inherit eutils

DESCRIPTION="Button Extension - mouse button rerouter daemon"
HOMEPAGE="http://www.ollisalonen.com/btnx/"
SRC_URI="http://www.ollisalonen.com/btnx/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64" #no tests on other systems
IUSE=""

DEPEND=">=dev-libs/libdaemon-0.10" #and needs uinput and udev in the kernel
PDEPEND=">=app-misc/btnx-config-0.4.9"

src_unpack() {
		unpack ${A}
		cd ${S}
}

src_compile() {
		econf init_tool=no || die "econf failed"
		emake || die "emake failed"
}

src_install() {
		emake DESTDIR="${D}" install || die "emake install failed."
		newinitd ${FILESDIR}/${PN}.initd ${PN}
		newconfd ${FILESDIR}/${PN}.conf ${PN}
		
		elog "You'll need the kernel module uinput and udev to use btnx."
		elog "Run btnx-config to configure btnx."
		elog "Run 'rc-update add btnx default' to start btnx on boot"
}
