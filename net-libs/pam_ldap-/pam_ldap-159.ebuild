# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/net-libs/pam_ldap/pam_ldap-156.ebuild,v 1.2 2002/12/09 04:33:13 manson Exp $

S=${WORKDIR}/${P}
DESCRIPTION="PAM LDAP Module"
HOMEPAGE="http://www.padl.com/pam_ldap.html"
SRC_URI="ftp://ftp.padl.com/pub/${P}.tar.gz"

DEPEND=">=sys-libs/glibc-2.1.3
	>=sys-libs/pam-0.72
	>=net-nds/openldap-1.2.11
	>=dev-libs/cyrus-sasl-2.1.7-r3
	>=dev-libs/openssl-0.9.6 "

SLOT="0"
LICENSE="GPL-2 | LGPL-2"
KEYWORDS="x86 sparc "

src_compile() {                           
	aclocal
	autoconf
	automake --add-missing

	./configure --host=${CHOST} \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--sysconfdir=/etc \
		--localstatedir=/var/lib \
		--with-ldap-lib=openldap || die

	emake || die
}

src_install() {                               

	exeinto /lib/security
	doexe pam_ldap.so
  
	dodoc pam.conf ldap.conf
	dodoc ChangeLog COPYING.* CVSVersionInfo.txt README
	docinto pam.d
	dodoc pam.d/*
}

