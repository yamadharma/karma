# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/net-libs/nss_ldap/nss_ldap-202.ebuild,v 1.1 2002/10/13 12:12:09 aliz Exp $

S=${WORKDIR}/${P}
DESCRIPTION="NSS LDAP Module"
HOMEPAGE="http://www.padl.com/nss_ldap.html"
SRC_URI="ftp://ftp.padl.com/pub/${P}.tar.gz"

DEPEND=">=net-nds/openldap-1.2.11"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="x86"

src_compile() {

	econf \
		--enable-schema-mapping \
		--enable-rfc2307bis \
		--enable-paged-results \
		--with-ldap-lib=openldap \
		--enable-extra-optimization || die

	emake UNIX_CAN_BUILD_STATIC=0 \
		OPTIMIZER="${CFLAGS}" || die
}

src_install() 
{                

	dodir /usr/lib

	make \
		DESTDIR=${D} \
		install || die
	
	dosym /etc/openldap/ldap.conf /etc/ldap.conf
	
	rm -rf ${D}/usr/usr

	dodoc ldap.conf ANNOUNCE NEWS ChangeLog AUTHORS COPYING
	dodoc CVSVersionInfo.txt README nsswitch.ldap
}
