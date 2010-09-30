# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils flag-o-matic autotools python

MY_P="${P/_rc/.rc}"
MY_PV="${PV/_pre/.pre}"

DESCRIPTION="The IPA authentication server "
HOMEPAGE="http://freeipa.org"
SRC_URI="http://freeipa.org/downloads/src/freeipa-${MY_PV}.tar.gz
	http://ftp.disconnected-by-peer.at/freeipa/1.2.x/freeipa-${MY_PV}.tar.gz"

LICENSE="GPL-2-with-exceptions"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="openldap"

DEPEND="virtual/krb5
	dev-libs/openssl
	dev-libs/nss
	dev-libs/nspr
	dev-libs/mozldap
	sys-libs/libcap
	net-nds/389-ds-base"

RDEPEND="dev-python/turbogears
	dev-python/freeipa-python
	net-dialup/freeipa-radius-server
	net-misc/freeipa-client
	net-nds/389-ds-base
	net-nds/389-admin
	www-apache/mod_python
	www-apache/mod_nss
	www-apache/mod_auth_kerb
	openldap? ( net-nds/openldap )"

PDEPEND="app-admin/freeipa-admintools"

S="${WORKDIR}/freeipa-${MY_PV}"/ipa-server

#pkg_setup() {
#	enewgroup dirsrv
#	enewuser dirsrv -1 -1 -1 dirsrv
#}

#python_need_rebuild

src_prepare() {
#	sed -e "s!nobody!dirsrv!g" -i configure.ac
	epatch "${FILESDIR}"/freeipa-1.2.2-gentoo_nss_nspr_path-1.patch
	epatch "${FILESDIR}"/freeipa-1.2.2-gentoo_svrcore_path-1.patch
	epatch "${FILESDIR}"/freeipa-1.2.2-gentoofy-1.patch
	emake -C ../ version-update
	eautoreconf
}

src_configure() {
	econf $(use_with openldap) || die "configure failed"
}


src_install() {
	emake DESTDIR="${D}" install || die "emake failed"

	# remove redhat style init script and install gentoo style
	rm -rf "${D}"/etc/rc.d
	rm -rf "${D}"/etc/default
	newinitd "${FILESDIR}"/ipa_kpasswd.initd ipa_kpasswd
	newinitd "${FILESDIR}"/ipa_webgui.initd ipa_webgui

	keepdir /var/lib/lib/ipa/sysrestore
	keepdir /var/lib/cache/ipa/sessions
	keepdir /var/lib/cache/ipa/kpasswd
#	die
}

pkg_postinst() {
	chown apache:apache ${ROOT}/var/lib/lib/ipa/sysrestore
	chown apache:apache ${ROOT}/var/lib/cache/ipa/sessions
	chown apache:apache ${ROOT}/var/lib/cache/ipa/kpasswd
}
