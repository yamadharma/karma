# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit apache-module eutils

KEYWORDS="amd64 ~sparc x86"

DESCRIPTION="An Apache 2.0 module for doing suid CGIs."
HOMEPAGE="http://directory.fedora.redhat.com/"
SRC_URI="http://directory.fedoraproject.org/sources/fedora-ds-admin-${PV}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/fedora-ds-admin-${PV}/${PN}"

APACHE2_MOD_CONF="48_${PN}"
APACHE2_MOD_DEFINE="RESTARTD"

DOCFILES="COPYING README"

need_apache2

src_unpack() {
        unpack ${A}
        cd ${S}
        epatch ${FILESDIR}/${PN}-1.0-prefix-config-1.patch
}

src_compile() {
	econf --with-apxs=${APXS} \
	|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	apache-module_src_install
}
