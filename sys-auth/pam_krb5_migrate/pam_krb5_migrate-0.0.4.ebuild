# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic

DESCRIPTION="Pam module for MIT Kerberos V"

SRC_URI="ftp://ftp.netexpress.net/pub/pam/${P}.tgz"
HOMEPAGE="ftp://ftp.netexpress.net/pub/pam"

SLOT="0"
LICENSE="BSD GPL-2 as-is"
KEYWORDS="x86 sparc "

DEPEND="virtual/krb5
	sys-libs/pam"

S=${WORKDIR}/${P}

src_unpack () 
{
  unpack ${A}
  cd ${S}
  sed -e "s:-I/usr/kerberos/include:-I/usr/include -I/usr/include/krb5:g" Makefile > Makefile.tmp
  mv Makefile.tmp Makefile

  cp Makefile Makefile.local
  sed -e "s:^KLOCAL:KLOCAL = -DKADMIN_LOCAL:g" Makefile.local > Makefile.tmp
  mv Makefile.tmp Makefile.local

  sed -e "s:-lkadm5clnt:-lkadm5srv:g" Makefile.local > Makefile.tmp
  mv Makefile.tmp Makefile.local

  sed -e "s:pam_krb5_migrate.so:pam_krb5_migrate_local.so:g" Makefile.local > Makefile.tmp
  mv Makefile.tmp Makefile.local

}


src_compile () 
{
	append-flags `krb5-config --cflags krb5 kadm-client`
	append-flags -fPIC

	make || die
	make -f Makefile.local || die
}

src_install() {
	exeinto /lib/security
	doexe pam_krb5_migrate.so
	doexe pam_krb5_migrate_local.so
#	dosym /lib/security/pam_krb5.so.1 /lib/security/pam_krb5.so

	dodoc COPYING CHANGELOG README INSTALL login.pam
}
