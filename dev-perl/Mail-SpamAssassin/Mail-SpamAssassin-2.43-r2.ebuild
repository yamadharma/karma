# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /home/cvsroot/gentoo-x86/dev-perl/Mail-SpamAssassin/Mail-SpamAssassin-2.31-r3.ebuild,v 1.7 2002/08/14 04:32:33 murphy Exp $

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
	net-mail/razor"

mydoc="License TODO Changes procmailrc.example sample-nonspam.txt sample-spam.txt"
myinst="${myinst} LOCAL_RULES_DIR=${D}/etc/mail/spamassassin"
myconf="${myconf} SYSCONFDIR=${D}/etc INST_PREFIX=/usr INST_SYSCONFDIR=/etc"

src_prep() 
{
	perl-module_src_prep
	dodir /etc/mail/spamassassin
}


src_install () {
	
	perl-module_src_install
	
	dodir /etc/init.d /etc/conf.d
	cp ${FILESDIR}/spamd.init ${D}/etc/init.d/spamd
	chmod +x ${D}/etc/init.d/spamd
	cp ${FILESDIR}/spamd.conf ${D}/etc/conf.d/spamd
	#
	docinto rules ; dodoc rules/*
	docinto masses ; dodoc masses/*
	docinto sql ; dodoc sql/*
	docinto spamproxy ; dodoc spamproxy/*
	docinto spamd ; dodoc spamd/README.*
}

