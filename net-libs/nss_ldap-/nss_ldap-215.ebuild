# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/net-libs/nss_ldap/nss_ldap-210.ebuild,v 1.3 2003/09/11 01:25:54 msterret Exp $


inherit fixheadtails

IUSE="berkdb ssl debug"

DESCRIPTION="NSS LDAP Module"
HOMEPAGE="http://www.padl.com/OSS/nss_ldap.html"
SRC_URI="http://www.padl.com/download/${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="x86 ~sparc"

DEPEND=">=net-nds/openldap-1.2.11
	berkdb? ( =sys-libs/db-3.2* )
	>=net-nds/openldap-1.2.11
	>=dev-libs/cyrus-sasl-2.1.7-r3
	ssl?	>=dev-libs/openssl-0.9.6"

src_unpack () 
{
	unpack ${A}
	# fix head/tail stuff
	ht_fix_file ${S}/Makefile.am ${S}/Makefile.in ${S}/depcomp ${S}/config.guess
}

src_compile () 
{
	local myconf=""
	# --enable-schema-mapping   enable attribute/objectclass mapping
	# --enable-paged-results    enable paged results control
	# --enable-configurable-krb5-ccname   enable configurable
	#			Kerberos V credentials cache name

	myconf="${myconf} `use_enable debug debugging`"
	myconf="${myconf} `use_enable ssl`"
	use berkdb && myconf="${myconf} --enable-rfc2307bis"

#	CPPFLAGS="-I/usr/include/db3 -I/usr/include/heimdal" \
	econf \
	    --libdir=/lib \
	    --enable-schema-mapping \
	    --enable-mssfu-schema \
	    --enable-paged-results \
	    --with-ldap-lib=openldap \
	    --enable-extra-optimization || die "configure failed"

	sed -i -e "s:-ldb :-ldb-3 :g" Makefile

	emake UNIX_CAN_BUILD_STATIC=0 \
		OPTIMIZER="${CFLAGS}" || die "make failed"
}



src_install() 
{                

	dodir /lib

	make \
	    DESTDIR=${D} \
	    install || die "make install failed"
	
	insinto /etc/openldap
	doins ldap.conf
	
	dosym /etc/openldap/ldap.conf /etc/ldap.conf
	
#	rm -rf ${D}/usr/usr

	dodoc ldap.conf ANNOUNCE NEWS ChangeLog AUTHORS COPYING
	dodoc CVSVersionInfo.txt README nsswitch.ldap LICENSE*
	
	docinto docs 
	dodoc doc/*
}
