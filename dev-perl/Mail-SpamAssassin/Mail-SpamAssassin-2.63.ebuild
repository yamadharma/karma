# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /home/cvsroot/gentoo-x86/dev-perl/Mail-SpamAssassin/Mail-SpamAssassin-2.31-r3.ebuild,v 1.7 2002/08/14 04:32:33 murphy Exp $

inherit perl-module patch

IUSE="berkdb ssl"

S=${WORKDIR}/${P}
DESCRIPTION="Perl Mail::SpamAssassin - A program to filter spam"
SRC_URI="http://www.spamassassin.org/released/${P}.tar.gz"
HOMEPAGE="http://www.spamassassin.org"

SLOT="0"
LICENSE="GPL-2 | Artistic"
KEYWORDS="x86 ppc sparc sparc64"


newdepend ">=dev-perl/ExtUtils-MakeMaker-6.11-r1
	dev-perl/Time-Local
	dev-perl/Time-HiRes
	dev-perl/Getopt-Long
	>=dev-perl/File-Spec-0.8
	>=dev-perl/PodParser-1.22
	>=dev-perl/HTML-Parser-3.24
	dev-perl/Net-DNS
	dev-perl/Digest-SHA1
	>=dev-perl/Mail-Audit-1.9
	ssl?    ( dev-perl/IO-Socket-SSL )
	berkdb? ( dev-perl/DB_File )"


#mydoc="License TODO Changes procmailrc.example sample-nonspam.txt sample-spam.txt"
myinst="${myinst} LOCAL_RULES_DIR=${D}/etc/mail/spamassassin"

myconf="CONTACT_ADDRESS=root@localhost"
myconf="${myconf} RUN_RAZOR1_TESTS=n RUN_RAZOR2_TESTS=y"

# If ssl is enabled, spamc can be built with ssl support
if use ssl 
    then
    myconf="${myconf} ENABLE_SSL=yes"
fi

# if you are going to enable taint mode, make sure that the bug where
# spamd doesn't start when the PATH contains . is addressed, and make
# sure you deal with versions of razor <2.36-r1 not being taint-safe.
# <http://bugzilla.spamassassin.org/show_bug.cgi?id=2511> and
# <http://spamassassin.org/released/Razor2.patch>.

myconf="${myconf} PERL_TAINT=no"

# No settings needed for 'make all'.
mymake=""

# Neither for 'make install'.
#myinst=""

# Some more files to be installed (README* and Changes are already
# included per default)
mydoc="License
	COPYRIGHT
	TRADEMARK
	CONTRIB_CERT
	BUGS
	USAGE
	procmailrc.example
	sample-nonspam.txt
	sample-spam.txt "


#src_compile () 
#{
#	perl-module_src_compile
#	perl-module_src_test
#}


src_compile () 
{
#    if ( use ssl )
#    then
#      CFLAGS="${CFLAFS} -DSPAMC_SSL"
#    fi
#
    perl-module_src_compile
#    perl-module_src_test

    cd ${S}
    make spamd/libspamc.so


    if ( use ssl )
    then
      make spamd/sslspamc
      make spamd/libsslspamc.so
    fi    
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

    dodir /etc/mail/spamassassin    
#    keepdir /var/spool/amavis /var/lib/amavis /var/lib/amavis/virusmails
    fowners mail:mail /etc/mail/spamassassin    
#    fperms 0750 /var/spool/amavis /var/lib/amavis /var/lib/amavis/virusmails

	
}

pkg_postinst () 
{
	perl-module_pkg_postinst

	if [ -z "`best_version dev-perl/DB_File`" ]; then
		einfo "The Bayes backend requires the Berkeley DB to store its data. You"
		einfo "need to emerge dev-perl/DB_File to make it available."
	fi

}
