# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit apache-module ssl-cert eutils

KEYWORDS="amd64 ~sparc x86"

DESCRIPTION="An Apache 2.0 module for implementing the admin server functionality required by Fedora Admin Server and Directory Server"
HOMEPAGE="http://directory.fedora.redhat.com/"
SRC_URI="http://directory.fedoraproject.org/sources/fedora-ds-admin-${PV}.tar.bz2"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="mozldap"

DEPEND=">=dev-libs/mozldap-6.0.2
        >=dev-libs/adminutil-1.1.3
	>=dev-libs/nss-3.11.4
        >=dev-libs/nspr-4.6.4
        >=dev-libs/icu-3.4"
RDEPEND="${DEPEND}"

S="${WORKDIR}/fedora-ds-admin-${PV}/${PN}"

#APACHE2_MOD_CONF="48_${PN}"
APACHE2_MOD_DEFINE="ADMSERV"

DOCFILES="LICENSE README"

need_apache2

pkg_setup() {
        if ( use mozldap && ! built_with_use 'dev-libs/apr-util' mozldap ) ; then
                eerror "dev-libs/apr-util is missing Mozilla LDAP support. For apache to have"
                eerror "mozldap support, apr-util must be built with the mozldap USE-flag"
                eerror "enabled."
                die "mozldap USE-flag enabled while not supported in apr-util"
        fi
}

src_compile() {
	econf --with-apxs=${APXS} \
	|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	apache-module_src_install
}
