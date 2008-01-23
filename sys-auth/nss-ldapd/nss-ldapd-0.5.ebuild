# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/nss_ldap/nss_ldap-254.ebuild,v 1.1 2007/02/06 04:50:25 robbat2 Exp $

inherit fixheadtails eutils multilib flag-o-matic

IUSE="debug sasl kerberos"

DESCRIPTION="NSS library for name lookups using LDAP"
HOMEPAGE="http://ch.tudelft.nl/~arthur/nss-ldapd/"
SRC_URI="http://ch.tudelft.nl/~arthur/nss-ldapd/${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="~alpha amd64 ~hppa ~mips ~ppc ~ppc64 ~sparc x86"

DEPEND=">=net-nds/openldap-2.1.30-r5
		sasl? ( dev-libs/cyrus-sasl )
		kerberos? ( virtual/krb5 )"

RDEPEND="${DEPEND}
	!sys-auth/nss_ldap"

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	keepdir /var/run/nslcd
		
	newinitd "${FILESDIR}"/nslcd.initd nslcd

	dodoc AUTHORS COPYING ChangeLog HACKING INSTALL NEWS README TODO nss-ldapd.conf
}
