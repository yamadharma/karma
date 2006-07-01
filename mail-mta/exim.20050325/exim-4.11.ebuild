# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Jerry Alexandratos <jerry@gentoo.org>
# Updated to exim-4 by Ben Lutgens <lamer@gentoo.org>

IUSE="tcpd ssl postgres mysql ldap pam mta.ldap mta.mysql"

ETYPE="sources"

S=${WORKDIR}/${P}
SA_EXIM_V=2.2
EXISCAN_V=${PV}-19
S_SA=${WORKDIR}/sa-exim-${SA_EXIM_V}
DESCRIPTION="A highly configurable, drop-in replacement for sendmail"
SRC_URI="ftp://ftp.exim.org/pub/exim/exim4/${P}.tar.gz 
  mta.spam.sa? mirror://sourceforge/sa-exim/sa-exim-${SA_EXIM_V}.tar.gz
  http://duncanthrax.net/exiscan/exiscan-${EXISCAN_V}.tar.gz"
HOMEPAGE="http://www.exim.org/"

DEPEND="virtual/glibc
		>=sys-libs/db-3.2
		>=dev-lang/perl-5.6.0
		>=dev-libs/libpcre-3.4
		pam? ( >=sys-libs/pam-0.75 )
		tcpd? ( sys-apps/tcp-wrappers )
		ssl?  ( >=dev-libs/openssl-0.9.6 )
		mta.tls?  ( >=dev-libs/openssl-0.9.6 )
		ldap? ( >=net-nds/openldap-2.0.7 )
		mta.ldap? ( >=net-nds/openldap-2.0.7 )
		mysql? ( >=dev-db/mysql-3.23.28 )
		mta.mysql? ( >=dev-db/mysql-3.23.28 )
		postgres? ( >=dev-db/postgresql-7 )
		net-mail/ripmime"

RDEPEND="${DEPEND}
		 !virtual/mta
		 >=net-mail/mailbase-0.00"

PROVIDE="virtual/mta"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 sparc sparc64"


src_unpack() {

	local myconf
	local mylibs
	unpack ${A}
	cd ${S}

	use mta.spam.sa && patch -p1 < ../sa-exim-${SA_EXIM_V}/localscan_dlopen.patch
	patch -p1 < ../exiscan-${EXISCAN_V}/exiscan-${EXISCAN_V}.patch
	
	# Don't need this in exim4 dir exists
	#mkdir Local
	sed -e "48i\CFLAGS=${CFLAGS}" \
		-e "s:# AUTH_CRAM_MD5=yes:AUTH_CRAM_MD5=yes:" \
		-e "s:# AUTH_PLAINTEXT=yes:AUTH_PLAINTEXT=yes:" \
		-e "s:BIN_DIRECTORY=/usr/exim/bin:BIN_DIRECTORY=/usr/sbin:" \
		-e "s:COMPRESS_COMMAND=/opt/gnu/bin/gzip:COMPRESS_COMMAND=/usr/bin/gzip:" \
		-e "s:ZCAT_COMMAND=/opt/gnu/bin/zcat:ZCAT_COMMAND=/usr/bin/zcat:" \
		-e "s:CONFIGURE_FILE=/usr/exim/configure:CONFIGURE_FILE=/etc/exim/configure:" \
		-e "s:EXIM_MONITOR=eximon.bin:# EXIM_MONITOR=eximon.bin:" \
		-e "s:# EXIM_PERL=perl.o:EXIM_PERL=perl.o:" \
		-e "s:# INFO_DIRECTORY=/usr/local/info:INFO_DIRECTORY=/usr/share/info:" \
		-e "s:# LOG_FILE_PATH=syslog:LOG_FILE_PATH=syslog:" \
		-e "s:LOG_FILE_PATH=syslog\:/var/log/exim_%slog::" \
		-e "s:# PID_FILE_PATH=/var/lock/exim%s.pid:PID_FILE_PATH=/var/run/exim%s.pid:" \
		-e "s:# SPOOL_DIRECTORY=/var/spool/exim:SPOOL_DIRECTORY=/var/spool/exim:" \
		-e "s:# SUPPORT_MAILDIR=yes:SUPPORT_MAILDIR=yes:" \
		-e "s:# SUPPORT_MAILSTOR=yes:SUPPORT_MAILSTORE=yes:" \
		-e "s:# SUPPORT_MBX=yes:SUPPORT_MBX=yes:" \
		-e "s:EXIM_USER=:EXIM_USER=mail:" \
		-e "s:# AUTH_SPA=yes:AUTH_SPA=yes:" \
		-e "s:# TRANSPORT_LMTP=yes:TRANSPORT_LMTP=yes:" \
		src/EDITME > Local/Makefile

	if use mta.tls; then
		cp Local/Makefile Local/Makefile.tmp
		sed -e "s:# SUPPORT_TLS=yes:SUPPORT_TLS=yes:" \
			-e "s:# TLS_LIBS=-lssl -lcrypto:TLS_LIBS=-lssl -lcrypto:" Local/Makefile.tmp > Local/Makefile
	fi
	if use mta.ldap; then
		mylibs="${mylibs} -lldap -llber"
		cp Local/Makefile Local/Makefile.tmp
		sed -e "s:# LOOKUP_LDAP=yes:LOOKUP_LDAP=yes:" \
			-e "s:# LOOKUP_INCLUDE=-I /usr/local/ldap/include -I /usr/local/mysql/include -I /usr/local/pgsql/include:LOOKUP_INCLUDE=-I/usr/include/ldap -I/usr/include/mysql:" \
			-e "s:# LDAP_LIB_TYPE=OPENLDAP2:LDAP_LIB_TYPE=OPENLDAP2:" Local/Makefile.tmp > Local/Makefile
	fi
	if use mta.mysql; then
		mylibs="${mylibs} -lmysqlclient"
		cp Local/Makefile Local/Makefile.tmp
		sed -e "s:# LOOKUP_MYSQL=yes:LOOKUP_MYSQL=yes:" \
			Local/Makefile.tmp > Local/Makefile
	fi
	
	cp Local/Makefile Local/Makefile.tmp
	sed -e  "s:# LOOKUP_LIBS=-L/usr/local/lib -lldap -llber -lmysqlclient -lpq:LOOKUP_LIBS=-L/usr/lib ${mylibs}:" Local/Makefile.tmp > Local/Makefile

	cd Local
	if use pam; then
		cp Makefile Makefile.orig
		sed -e "s:# SUPPORT_PAM=yes:SUPPORT_PAM=yes:" Makefile.orig > Makefile
		myconf="${myconf} -lpam"
	fi
	if use tcpd; then
		cp Makefile Makefile.orig
		sed -e "s:# USE_TCP_WRAPPERS=yes:USE_TCP_WRAPPERS=yes:" Makefile.orig > Makefile
		myconf="${myconf} -lwrap"
	fi
	if [ -n "$myconf" ] ; then
		echo "EXTRALIBS=${myconf}" >> Makefile
	fi

	cd ${S}
	cat Makefile | sed -e 's/^buildname=.*/buildname=exim-gentoo/g' > Makefile.gentoo && mv -f Makefile.gentoo Makefile
}


src_compile() {
	make || die
	if (use mta.spam.sa); then
	  cd ${S_SA}
	  make SACONF=/etc/exim/sa-exim.conf EXIM_SRC=${S}/src
	fi
}


src_install () {

	cd ${S}/build-exim-gentoo
	insopts -o root -g root -m 4755
	insinto /usr/sbin
	doins exim

	dodir /usr/bin /usr/sbin /usr/lib
	dosym /usr/sbin/exim /usr/bin/mailq
	dosym /usr/sbin/exim /usr/bin/newaliases
	dosym /usr/sbin/exim /usr/bin/mail
	dosym /usr/sbin/exim /usr/lib/sendmail
	dosym /usr/sbin/exim /usr/sbin/sendmail

	exeinto /usr/sbin
	for i in exicyclog exim_dbmbuild exim_dumpdb exim_fixdb exim_lock \
		exim_tidydb exinext exiwhat exigrep eximstats exiqsumm
	do
		doexe $i
	done
	
	# This stuff shows up in ${S}/exim-build-gentoo now. Wierd.
	#cd ${S}/util
	#exeinto /usr/sbin
	#for i in exigrep eximstats exiqsumm
	#do
	#	doexe $i
	#done

#	dodir /etc/exim /etc/exim/samples
	
#	insopts -o root -g root -m 0644
#	insinto /etc/exim/samples
#	doins ${FILESDIR}/smtp-auth-tls-client-configure
	cd ${S}/src
	insopts -o root -g root -m 0644
	insinto /etc/exim
	doins configure.default

	dodoc ${S}/doc/*
	doman ${S}/doc/exim.8
	# INSTALL a pam.d file for SMTP AUTH that works with gentoo's pam
	insinto /etc/pam.d
	doins ${FILESDIR}/pam.d-exim

	# A nice filter for exim to protect your windows clients.
	insinto /etc/exim
	doins ${FILESDIR}/system_filter.exim
	dodoc ${FILESDIR}/auth_conf.sub

	exeinto /etc/init.d
	newexe ${FILESDIR}/exim.rc6 exim
	insinto /etc/conf.d
	newins ${FILESDIR}/exim.confd exim
	
	##{{{ sa-exim
	
	if (use mta.spam.sa); then
	  cd ${S_SA}
	  insinto /etc/exim
	  newins spamassassin.conf sa-exim.conf.example
	  
	  insinto /usr/lib/exim/4/local_scan
	  doins accept.so sa-exim-${SA_EXIM_V}.so
	  dosym /usr/lib/exim/4/local_scan/sa-exim-${SA_EXIM_V}.so /usr/lib/exim/4/local_scan/sa-exim.so
	  
	  docinto sa-exim
	  dodoc sa.html README INSTALL
	  
	  cd ${D}/etc/exim
	  sed -e "43i\local_scan_path = /usr/lib/exim/4/local_scan/sa-exim.so" configure.default > configure.default.tmp
	  mv -f configure.default.tmp configure.default
	fi
	
	##}}}
}


pkg_config() {

	${ROOT}/usr/sbin/rc-update add exim
}
pkg_postinst() {
	einfo "Read the bottom of /etc/exim/system_filter.exim for usage."
	einfo "/usr/share/doc/${P}/auth_conf.sub.gz contains the configuration sub for using smtp auth."
	einfo "Please create /etc/exim/configure from /etc/exim/configure.default."
	einfo "Also see /etc/exim/samples dir for example configs."
}
