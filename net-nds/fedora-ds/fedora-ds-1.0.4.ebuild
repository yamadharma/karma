# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic

IUSE="java"

PV_SNMP="5.2.1"
PV_KRB5="1.4.3"
PV_SASL="2.1.20"
PV_ICU="2.4"
PV_DB="4.2.52.NC"

DESCRIPTION="Fedora Directory Server"
HOMEPAGE=""
#SRC_URI="http://directory.fedora.redhat.com/sources/db-${PV_DB}.tar.gz
#	http://directory.fedora.redhat.com/sources/icu-${PV_ICU}.tgz
#	http://directory.fedora.redhat.com/sources/mozilla-components-2.tar.gz
#	http://directory.fedora.redhat.com/sources/cyrus-sasl-${PV_SASL}.tar.gz
#	http://web.mit.edu/kerberos/dist/krb5/1.4/krb5-${PV_KRB5}-signed.tar
#	http://directory.fedora.redhat.com/sources/net-snmp-${PV_SNMP}.tar.gz
#	http://directory.fedora.redhat.com/sources/fedora-ds-${PV}.tar.gz
#	http://directory.fedora.redhat.com/sources/fedora-setuputil-${PV}.tar.gz
#	http://directory.fedora.redhat.com/sources/fedora-adminutil-${PV}.tar.gz
#	java? ( http://directory.fedora.redhat.com/sources/fedora-directoryconsole-${PV}.tar.gz
#		http://directory.fedora.redhat.com/sources/fedora-dsonlinehelp-${PV}.tar.gz
#		http://directory.fedora.redhat.com/sources/fedora-adminserver-${PV}.tar.gz
#		http://directory.fedora.redhat.com/sources/fedora-onlinehelp-${PV}.tar.gz
#		http://directory.fedora.redhat.com/sources/fedora-console-${PV}.tar.gz )"

SRC_URI="http://directory.fedora.redhat.com/sources/fedora-ds-${PV}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

RDEPEND="java? ( virtual/jdk )"

DEPEND="${RDEPEND}
	app-arch/zip
	java? ( dev-java/ant )"

S=${WORKDIR}/${P}
S_DB=${WORKDIR}/db-${PV_DB}
S_ICU=${WORKDIR}/icu
S_MOZ=${WORKDIR}/mozilla
S_SASL=${WORKDIR}/cyrus-sasl-${PV_SASL}
S_KRB5=${WORKDIR}/krb5-${PV_KRB5}
S_SNMP=${WORKDIR}/net-snmp-${PV_SNMP}
S_UTIL=${WORKDIR}/fedora-setuputil-${PV}
S_ADMIN=${WORKDIR}/fedora-adminutil-${PV}
S_ADMINSRV=${WORKDIR}/fedora-adminserver-${PV}
S_CONSOLE=${WORKDIR}/fedora-console-${PV}
S_DIRCONSOLE=${WORKDIR}/fedora-directoryconsole-${PV}

src_unpack() {
	unpack ${A}
#	cd ${WORKDIR}
#	tar -xzf krb5-${PV_KRB5}.tar.gz

	#
	# Patch Cyrus-SASL
	#
#	cd ${S_SASL}
#	epatch ${FILESDIR}/cyrus-sasl-2.1.20-gcc4.patch

	#
	# Patch DB
	#
#	cd ${S_DB}
#	for x in 1 2 3 4; do
#		epatch ${FILESDIR}/patch.${PV_DB//.NC/}.${x}
#	done

	#
	# Patch Fedora-DS
	#
#	cd ${S}
#	epatch ${FILESDIR}/ldapserver-gcc4.patch

	# fix path to adminutil and sasl files
#	sed -i  -e "s:/built/adminutil/:/built/:" \

#	sed -i	-e "s:SASL_INCDIR = /usr/include/sasl:SASL_INCDIR = \$(SASL_SOURCE_ROOT)/include:" \
#		-e "s:SASL_LIBPATH = /usr/lib:SASL_LIBPATH = \$(SASL_SOURCE_ROOT)/lib:" \
#		${S}/components.mk

	#
	# Misc
	#

	# use the right source for version info
#	find ${S} ${S_ADMIN} ${S_UTIL} ${S_ADMINSRV} -type f \( -name "Makefile" -or -name "*.mk" \) \
#		-exec sed -i -e "s:cat /etc/redhat-release:cat /etc/gentoo-release:" {} 2>/dev/null \;
#			     -e "s:/built/release:/built:" {} 2>/dev/null \;

	# adminutil Makefile
#	sed -i  -e "s:/built/adminutil/:/built/:" \
#		-e "s:/built/package/:/built/:" \
#		-e "s:\$(ADMINUTIL_SOURCE_ROOT)/built/\$(PLATFORM_DEST)/include:\$(ADMINUTIL_SOURCE_ROOT)/include:" \
#		${S_ADMINSRV}/nsconfig.mk

	#
	# damn, i spent hours trying to track this one down...
	# don't use make's basename to strip linux version numbers,
	# works fine for a.b.c, but breaks with new a.b.c.d scheme
	#
#	find ${WORKDIR} -type f -name "nsdefs.mk" -exec sed -i \
#		-e "s:\$(basename \$(NSOS_RELEASE)):\$(shell echo \$(NSOS_RELEASE) | grep -o \"^.\\\..\"):" {} \;

	#
	# Patches
	#
	cd ${S}
#	epatch ${FILESDIR}/fedora-ds-1.0-dsmake.diff
}

src_compile() {
	append-flags -I/usr/include/fedora-ds -I/usr/include
	
	local USE_JAVA
	local DS_OPTS

	#
	# Net-SNMP
	#
#	einfo "Building net-snmp-${PV_SNMP}..."
#	cd ${S_SNMP}
#	./configure \
#		--host=${CHOST} \
#		--with-logfile="" \
#		--with-default-snmp-version="3" \
#		--with-sys-contact="root@Unknown" \
#		--with-sys-location="Unknown" \
#		--with-persistent-directory=/var/lib/net-snmp \
#		--with-mib-modules="" \
#		--disable-applications \
#		--disable-manuals \
#		--disable-scripts \
#		--disable-mibs \
#		--prefix=${S_SNMP}/built || die "configure net-snmp failed"
#	make all install || die "make net-snmp failed"

	#
	# KRB5
	#
#	einfo "Building mit-krb5-${PV_KRB5}..."
#	cd ${S_KRB5}/src
#	./configure \
#		--host=${CHOST} \
#		--enable-static \
#		--without-krb4 \
#		--prefix=${S_KRB5}/built || die "configure krb5 failed"
#	make all install || die "make krb5 failed"

	#
	# Cyrus-SASL
	#
#	einfo "Building cyrus-sasl-${PV_SASL}..."
#	cd ${S_SASL}
#	./configure \
#		--host=${CHOST} \
#		--enable-static \
#		--without-des \
#		--without-openssl \
#		--enable-gssapi=${S_KRB5}/built || die "configure sasl failed"
#	make || die "make sasl failed"

	#
	# ICU
	#
#	einfo "Building icu-${PV_ICU}..."
#	cd ${S_ICU}/source
#
#	./runConfigureICU LinuxRedHat \
#		--host=${CHOST} \
#		--enable-rpath \
#		--disable-ustdio \
#		--prefix=${S_ICU}/built || die "configure icu failed"
#	make all install || die "make icu failed"

	#
	# DB
	#
#	einfo "Building db-${PV_DB}..."
#	mkdir -p ${S_DB}/built
#	cd ${S_DB}/built
#
#	../dist/configure \
#		--host=${CHOST} \
#		--prefix=/usr \
#		--mandir=/usr/share/man \
#		--infodir=/usr/share/info \
#		--datadir=/usr/share \
#		--sysconfdir=/etc \
#		--localstatedir=/var/lib \
#		--libdir=/usr/$(get_libdir) \
#		--disable-compat185 \
#		--enable-cxx \
#		--with-uniquename \
#		${myconf} || die

#	make LIBDB_ARGS="libdb.a" || die "make db failed"
#	make LDFLAGS="-static " libdb.a all || die "make db static failed"

	#
	# Mozilla
	#
#	einfo "Building Mozilla components..."
#	cd ${S_MOZ}/security/nss
#	make BUILD_OPT=1 nss_build_all || die "make nss failed"
#
#	cd ${S_MOZ}/security/svrcore
#	make BUILD_OPT=1 || die "make svrcore failed"
#
#	cd ${S_MOZ}/directory/c-sdk
#	econf --with-nss --enable-optimize || die "configure c-sdk failed"
#	make BUILDCLU=1 HAVE_SRVCORE=1 BUILD_OPT=1 || die "make c-sdk failed"
#
#	cd ${S_MOZ}/directory/perldap
#	LDAPSDKDIR=${S_MOZ}/directory/c-sdk \
#	LDAPSDKSSL=yes NSPRDIR=`echo ../../dist/*.OBJ` \
#		perl Makefile.PL || die "creating perldap Makefile failed"

#	make || die "make perldap failed"

	#
	# Fedora-adminutil
	#
#	einfo "Building adminutil..."
#	cd ${S_ADMIN}
#	make \
#		BUILD_DEBUG=optimize \
#		ICU_SOURCE_ROOT=${S_ICU} \
#		MOZILLA_SOURCE_ROOT=${S_MOZ} \
#		SECURITY_SOURCE_ROOT=${S_MOZ} \
#		|| die "make adminutil failed"

	#
	# Fedora-setuputil
	#
#	einfo "Building setuputil..."
#	cd ${S_UTIL}
#	make \
#		BUILD_DEBUG=optimize \
#		ICU_SOURCE_ROOT=${S_ICU} \
#		DBM_SOURCE_ROOT=${S_MOZ} \
#		SRVCORE_SOURCE_ROOT=${S_MOZ} \
#		SECURITY_SOURCE_ROOT=${S_MOZ} \
#		|| die "make setuputil failed"
#
#	if use java
#	then
#		USE_JAVA=1
#
#		#
#		# Fedora-console
#		#
#		einfo "Building console..."
#		cd ${S_CONSOLE}
#		ant -Dimports.file=imports.Gentoo || die "building console failed"
#
#		#
#		# Fedora-adminserver
#		#
#		einfo "Building adminserver..."
#		cd ${S_ADMINSRV}
#		make \
#			BUILD_DEBUG=optimize \
#			ICU_SOURCE_ROOT=${S_ICU} \
#			SETUPUTIL_SOURCE_ROOT=${S_UTIL} \
#			ADMINUTIL_SOURCE_ROOT=${S_ADMIN} \
#			MOZILLA_SOURCE_ROOT=${S_MOZ} \
#			SECURITY_SOURCE_ROOT=${S_MOZ} \
#			|| die "make adminutil failed"
#
#		DS_OPTS="ONLINEHELP_SOURCE_ROOT=${WORKDIR}/fedora-dsonlinehelp-${PV} \
#			ADMINSERVER_SOURCE_ROOT=${S_ADMINSRV} \
#			LDAPCONSOLE_SOURCE_ROOT=${S_DIRCONSOLE}"
#
#	else
#		USE_JAVA=0
#	fi

	#
	# Fedora-DS
	#
	einfo "Building Fedora-DS..."
	cd ${S}
	make
#	make \
#		INSTDIR=${D} BUILD_JAVA_CODE=${USE_JAVA} USE_PERL_FROM_PATH=1 BUILD_DEBUG=optimize \
#		GET_JAVA_FROM_PATH=1 GET_ANT_FROM_PATH=1 USE_SETUPUTIL=1 USE_ADMINSERVER=${USE_JAVA} \
#		USE_CONSOLE=${USE_JAVA} USE_DSMLGW=0 USE_ORGCHART=0 USE_DSGW=0 USE_JAVATOOLS=0 \
#		DB_SOURCE_ROOT=${S_DB} \
#		ICU_SOURCE_ROOT=${S_ICU} \
#		SASL_SOURCE_ROOT=${S_SASL} \
#		NETSNMP_SOURCE_ROOT=${S_SNMP} \
#		SETUPUTIL_SOURCE_ROOT=${S_UTIL} \
#		ADMINUTIL_SOURCE_ROOT=${S_ADMIN} \
#		MOZILLA_SOURCE_ROOT=${S_MOZ} \
#		${DS_OPTS} LDFLAGS="-L${S_KRB5}/built/lib " || die "make DS failed"


#		LDAPJDK_DIR=${WORKDIR}/ldapjdk \
#		CRIMSONJAR_BUILD_DIR=${WORKDIR}/crimson \
#		DSMLGWJARS_BUILD_DIR=${WORKDIR}/dsmlgwjars \
}

#src_install() {
#}
