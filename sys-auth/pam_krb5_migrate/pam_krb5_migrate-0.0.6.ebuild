# Copyright 1999-2007 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic

DESCRIPTION="Pam module for MIT Kerberos V"

HOMEPAGE="http://www.freshmeat.net/projects/pam_krb5_migrate"
SRC_URI="http://samba.org/~jelmer/pam_krb5_migrate/${P//_/-}.tar.gz"

SLOT="0"
LICENSE="BSD GPL-2 as-is"
KEYWORDS="x86 sparc "

DEPEND="virtual/krb5
	sys-libs/pam"

S=${WORKDIR}/${P//_/-}

src_unpack ()
{
	unpack ${A}
	epatch ${FILESDIR}/configure.ac.patch
	epatch ${FILESDIR}/Makefile.patch
	epatch ${FILESDIR}/Makefile.settings.in.patch
	autoconf
}

src_compile () 
{
#	append-flags `krb5-config --cflags krb5 kadm-client`
#	append-flags -fPIC
	
	econf || die
	emake || die
}

src_install() {
	make install DESTDIR=${D} || die
#	exeinto /$(get_libdir)/security
#	doexe pam_krb5_migrate.so
	
#	doman pam_krb5_migrate.5
	
	dodoc COPYING CHANGELOG README INSTALL login.pam
}
