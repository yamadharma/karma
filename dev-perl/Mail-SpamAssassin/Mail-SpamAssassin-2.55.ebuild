# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /home/cvsroot/gentoo-x86/dev-perl/Mail-SpamAssassin/Mail-SpamAssassin-2.31-r3.ebuild,v 1.7 2002/08/14 04:32:33 murphy Exp $

IUSE="ssl"

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="Perl Mail::SpamAssassin - A program to filter spam"
SRC_URI="http://www.spamassassin.org/released/${P}.tar.gz"
HOMEPAGE="http://www.spamassassin.org"

SLOT="0"
LICENSE="GPL-2 | Artistic"
KEYWORDS="x86 ppc sparc sparc64"

DEPEND="dev-perl/Net-DNS
	dev-perl/Time-HiRes
	>=dev-perl/HTML-Parser-3.00
	dev-perl/Digest-SHA1
	>=dev-perl/Mail-Audit-1.9
	>=net-mail/razor-2*
	ssl? ( >=dev-libs/openssl-0.9.6g )"

mydoc="License TODO Changes procmailrc.example sample-nonspam.txt sample-spam.txt"
myinst="${myinst} LOCAL_RULES_DIR=${D}/etc/mail/spamassassin"
myconf="${myconf} SYSCONFDIR=${D}/etc INST_PREFIX=/usr INST_SYSCONFDIR=/etc RUN_RAZOR1_TESTS=n RUN_RAZOR2_TESTS=y"

#src_compile() 
#{
#  perl Makefile.PL PREFIX=${D}/usr \
#  RUN_RAZOR1_TESTS=y RUN_RAZOR2_TESTS=y \
#  INST_PREFIX=${D}/usr
#  
#  make
#  
#  dodir /etc/mail/spamassassin
#}

src_compile() 
{
    if ( use ssl )
    then
      CFLAGS="${CFLAFS} -DSPAMC_SSL"
    fi

    cd ${S}
    perl-module_src_prep

    cd ${S}
    make spamd/libspamc.so


    if ( use ssl )
    then
      make spamd/sslspamc
      make spamd/libsslspamc.so
    fi    
    
    dodir /etc/mail/spamassassin

}


src_install () 
{
	
    perl-module_src_install
    
    cd ${S}	
    dolib.so spamd/libspamc.so

    if ( use ssl )
    then
      dobin spamd/sslspamc
      dolib.so spamd/libsslspamc.so
    fi    
    
	
	dodir /etc/init.d /etc/conf.d
	cp ${FILESDIR}/spamd.init ${D}/etc/init.d/spamd
	chmod +x ${D}/etc/init.d/spamd
	cp ${FILESDIR}/spamd.conf ${D}/etc/conf.d/spamd
  ##
	sed -e "s:${D}::" ${D}/usr/bin/spamassassin > spamassassin.tmp
	mv spamassassin.tmp ${D}/usr/bin/spamassassin
	chmod 555 ${D}/usr/bin/spamassassin

	sed -e "s:${D}::" ${D}/usr/bin/spamd > spamd.tmp
	mv spamd.tmp ${D}/usr/bin/spamd
	chmod 555 ${D}/usr/bin/spamd
  ##
    cd {S}
    docinto rules ; cd {S}/rules ; dodoc *
    docinto masses ; cd {S}/masses ; dodoc *
    docinto sql ; cd {S}/sql ; dodoc *
#	docinto spamproxy ; dodoc {S}/spamproxy/*
    docinto spamd ; dodoc {S}/spamd/README.*
    
    cd {S}
    dodoc INSTALL* BUGS CONTRIB* COPYRIGHT USAGE
    
	
}

