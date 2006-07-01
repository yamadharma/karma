# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/net-libs/pam_ldap/pam_ldap-156.ebuild,v 1.2 2002/12/09 04:33:13 manson Exp $

IUSE="ssl"

S=${WORKDIR}/${P}
DESCRIPTION="PAM LDAP Module"
HOMEPAGE="http://www.padl.com/pam_ldap.html"
SRC_URI="ftp://ftp.padl.com/pub/${P}.tar.gz"

DEPEND=">=sys-libs/glibc-2.1.3
	>=sys-libs/pam-0.72
	>=net-nds/openldap-1.2.11
	>=dev-libs/cyrus-sasl-2.1.7-r3
	ssl?	>=dev-libs/openssl-0.9.6 "


SLOT="0"
LICENSE="GPL-2 | LGPL-2"
KEYWORDS="x86 sparc "

src_compile () 
{                           
	aclocal
	autoconf
	automake --add-missing
	
	local myconf=""

	myconf="${myconf} `use_enable ssl`"

	econf --with-ldap-lib=openldap \
	    --enable-rfc2307bis \
	    ${myconf} || die
	    
	emake || die
}

src_install () 
{                               
	exeinto /lib/security
	doexe pam_ldap.so
    
	insinto /etc/openldap/schema
	doins *.schema
  
	dodoc pam.conf ldap.conf certutil
	dodoc ChangeLog COPYING.* CVSVersionInfo.txt README 
	docinto pam.d
	dodoc pam.d/*
}

