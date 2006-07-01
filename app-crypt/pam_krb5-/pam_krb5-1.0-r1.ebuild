# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/app-crypt/pam_krb5/pam_krb5-1.0.ebuild,v 1.11 2002/12/09 04:17:38 manson Exp $

DESCRIPTION="Pam module for MIT Kerberos V"
SRC_URI="http://www.fcusack.com/soft/${P}.tar.gz"
HOMEPAGE="http://www.fcusack.com/"

SLOT="0"
LICENSE="BSD GPL-2 as-is"
KEYWORDS="~x86 sparc "

DEPEND="app-crypt/krb5
	sys-libs/pam"

S=${WORKDIR}/${PN}

src_compile() 
{
	patch -p0 < ${FILESDIR}/${P}-gentoo.diff || die
  cd ${S}
  sed -e "s:L_tmpnam + 8:L_tmpnam + 48:g" pam_krb5_auth.c > pam_krb5_auth.c.tmp
  mv -f pam_krb5_auth.c.tmp pam_krb5_auth.c
	
	make CFLAGS="$CFLAGS" || die
}

src_install() {
	exeinto /lib/security
	doexe pam_krb5.so.1
	dosym /lib/security/pam_krb5.so.1 /lib/security/pam_krb5.so

	doman pam_krb5.5
	dodoc COPYRIGHT README TODO
}
