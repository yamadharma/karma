# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit eutils multilib autotools

DESCRIPTION="Fedora Directory Server (admin)"
HOMEPAGE="http://directory.fedora.redhat.com/"
SRC_URI="http://directory.fedoraproject.org/sources/${P}.tar.bz2"

LICENSE="GPL-2-with-exceptions"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="sasl snmp ipv6 debug"

DEPEND=">=dev-libs/nss-3.11.4
        >=dev-libs/nspr-4.6.4
        >=dev-libs/svrcore-4.0.3
        >=dev-libs/mozldap-6.0.2
        sasl? ( >=dev-libs/cyrus-sasl-2.1.19 )
        >=dev-libs/icu-3.4
        >=sys-libs/db-4.2.52
        snmp? ( >=net-analyzer/net-snmp-5.1.2 )
        sys-apps/lm_sensors
        app-arch/bzip2
        dev-libs/openssl
        sys-apps/tcp-wrappers
        sys-libs/pam
        sys-libs/zlib
	!net-nds/fedora-ds"

src_unpack() {
        unpack ${A}
	cd ${S}
	sed -e "s!SUBDIRS!# SUBDIRS!g" -i Makefile.am
	rm -rf mod_*
	eautoreconf
}

src_compile() {
        if use amd64 ; then
                myconf="${myconf} --enable-64bit"
        elif use sasl ; then
                myconf="${myconf} --with-sasl=yes"
        elif use snmp ; then
                myconf="${myconf} --netsnmp=yes"
        else
                myconf=""
        fi

        econf $(use_enable debug) \
              ${myconf} \
              --with-fhs \
	      --with-httpd=/usr/sbin/apache2 \
	      || die "econf failed"
        emake || die "emake failed"

#             --with-nspr=yes \
#             --with-nss=yes \
#             --with-ldapsdk=yes \
#             --with-db=yes \
#             --with-svrcore=yes \
#             --with-icu=yes \

}

src_install () {
        emake DESTDIR=${D} install || die "emake failed"
		
	# remove redhat style init script.
	# we are on gentoo apache is build with mozldap 
	# no LD_PRELOAD required
        rm -rf ${D}/etc/rc.d
        rm -rf ${D}/etc/default
	
	# for now remove the *-ds-admin and no apacha restart
	# the sources must be patched to invoke init.d/apache2
	# or a script that handles the restart 
	rm -rf ${D}/usr/sbin/*-ds-admin	
}
