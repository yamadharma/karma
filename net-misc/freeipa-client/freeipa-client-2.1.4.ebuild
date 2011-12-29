# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils flag-o-matic autotools

MY_P="${P/_rc/.rc}"
MY_PV="${PV/_pre/.pre}"

DESCRIPTION="The IPA authentication server "
HOMEPAGE="http://freeipa.org"
SRC_URI="http://freeipa.org/downloads/src/freeipa-${MY_PV}.tar.gz"


LICENSE="GPL-2-with-exceptions"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="openldap"

DEPEND="virtual/krb5"

RDEPEND="dev-python/turbogears
	dev-python/python-krbV
	dev-python/freeipa-python
	dev-python/python-ldap
	sys-auth/pam_krb5
	sys-auth/nss_ldap
	openldap? ( net-nds/openldap )"

S="${WORKDIR}/freeipa-${MY_PV}"/ipa-client

src_prepare() {
	epatch "${FILESDIR}"/freeipa-1.2.2-gentoofy-1.patch
	emake -C ../ version-update
	eautoreconf
}

src_configure() {
	econf $(use_with openldap) || die "configure failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	keepdir /var/lib/ipa-client/
	keepdir /var/lib/ipa-client/sysrestore
	dodir /etc/ipa/
}

