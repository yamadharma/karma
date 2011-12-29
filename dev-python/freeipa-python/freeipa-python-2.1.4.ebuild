# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils flag-o-matic autotools distutils

MY_P="${P/_rc/.rc}"
MY_PV="${PV/_pre/.pre}"

DESCRIPTION="The IPA authentication server "
HOMEPAGE="http://freeipa.org"
SRC_URI="http://freeipa.org/downloads/src/freeipa-${MY_PV}.tar.gz"


LICENSE="GPL-2-with-exceptions"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/krb5"

RDEPEND="dev-python/turbogears
	dev-python/python-krbV
	dev-python/pykerberos
	dev-python/authconfig
	dev-python/python-ldap
	dev-python/pyasn1
	app-crypt/gnupg"

S="${WORKDIR}/freeipa-${MY_PV}"/ipapython

src_prepare() {
	emake -C ../ version-update
	distutils_src_prepare
}

