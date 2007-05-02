# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

IUSE="snmp"

DESCRIPTION="Fedora Directory Server"
HOMEPAGE=""

MY_PV=${PV/_pre/-}
MY_P=fedora-ds-base-${MY_PV}

SRC_URI="http://directory.fedora.redhat.com/sources/fds110a1/fedora-ds-${MY_PV}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64"

RDEPEND="java? ( virtual/jdk )"

DEPEND="${RDEPEND}
	app-arch/zip
	>=dev-libs/nspr-4.6.4
	>=dev-libs/nss-3.11.4
	dev-libs/svrcore
	dev-libs/mozldap
	dev-libs/cyrus-sasl
	>=dev-libs/icu-3.4
	dev-libs/openssl
	snmp? ( net-analyzer/net-snmp )
	java? ( dev-java/ant )"


S=${WORKDIR}/${MY_P}

src_compile() {

	local myconf
	
#	myconf="${myconf} `use_with snmp netsnmp`"

	cd ${S}
	econf --with-fhs \
	    ${myconf} || die
	emake || die
	
}

src_install() {
	make install DESTDIR=${D} || die
	
	insinto /usr/include/fedora-ds
	doins ${S}/ldap/servers/slapd/slapi-plugin.h
	
	# make sure perl scripts have a proper shebang 
	sed -i -e "s|#{{PERL-EXEC}}|#!/usr/bin/perl|" ${D}/usr/share/fedora-ds/script-templates/template-*.pl
	sed -i -e "s|#{{PERL-EXEC}}|#!/usr/bin/perl|" ${D}/usr/share/fedora-ds/script-templates/template-migrate*

	keepdir /var/lib/fedora-ds
	keepdir /var/log/fedora-ds
	keepdir /var/lock/fedora-ds
	keepdir /var/tmp/fedora-ds

	rm -rf ${D}/etc/rc.d
	newinitd ${FILESDIR}/fedora-ds.init fedora-ds
}
