# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils
DESCRIPTION="Open Source Security Information Management - Server"
HOMEPAGE="http://www.ossim.net/"
MY_PN="os-sim"
MY_P="${MY_PN}-${PV/_}"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=">=dev-libs/glib-2.9.0
	>=gnome-extra/libgda-1.2.0
	>=net-libs/gnet-2.0.7
	>=dev-libs/libxml2-2.6.22"
RDEPEND="${DEPEND}"

# S="${WORKDIR}/${MY_P}"
S=${WORKDIR}/${MY_PN}-${PV%_*}

MY_CONFDIR='/etc/ossim/server'

pkg_setup() {
	enewgroup ossim || die 'Cannot create ossim group.'
	enewuser ossim -1 -1 /etc/ossim ossim || die 'Cannot create ossim user.'
}

src_compile() {
	./autogen.sh --bindir="${ROOT}/usr/sbin" || die "autogen failed"

	cd "${S}/src"
	emake || die "emake failed"
}

src_install() {
	cd "${S}/src"
	emake DESTDIR="${D}" install || die "Installing ossim binary failed"
	newinitd ${FILESDIR}/${PN}.initd ${PN} || die 'init.d installation failed.'
	newconfd ${FILESDIR}/${PN}.confd ${PN} || die 'conf.d installation failed.'

	diropts "-m 0770 -o ossim -g ossim"
	dodir /var/log/ossim
	keepdir /var/log/ossim
	dodir ${MY_CONFDIR}
	cd "${S}/etc/server"
	emake DESTDIR="${D}" install || die "Installing ossim config files failed."

	cd "${S}"
	insinto etc/logrotate.d/ && doins etc/logrotate.d/${PN}
	doman doc/*.8
	dodoc doc/${PN}.xml
}

pkg_postinst() {
	chown ossim:ossim ${ROOT}/etc/ossim
	chown ossim:ossim ${ROOT}/var/log/ossim
}

