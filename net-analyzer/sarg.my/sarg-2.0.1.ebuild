# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Sarg (Squid Analysis Report Generator) is a tool that allows you to view where your users are going to on the Internet."
HOMEPAGE="http://sarg.sf.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
     http://sarg.sourceforge.net/sarg-2.0.1-largeurl.patch.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND="media-libs/gd"
RDEPEND="${DEPEND}
	>=www-proxy/squid-2.5.1"

HTMLDIR=/srv/www/sarg

src_unpack () 
{
    unpack ${A}
    cd ${S}
    epatch ${WORKDIR}/sarg-2.0.1-largeurl.patch
}

src_compile () 
{
    econf \
    	--enable-bindir=/usr/sbin \
    	--enable-mandir=/usr/man/man1 \
    	--enable-sysconfdir=/usr/share/sarg \
	--enable-htmldir=${HTMLDIR}	\
        || die "./configure failed"

    emake || die
}

src_install () 
{
    dodir /etc/sarg /usr/sbin /usr/man/man1 /usr/share/sarg /srv/www/sarg
    
    make \
    	BINDIR=${D}/usr/sbin \
	MANDIR=${D}/usr/man/man1 \
	SYSCONFDIR=${D}/usr/share/sarg \
	install || die
	
    mv ${D}/usr/share/sarg/sarg.conf ${D}/etc/sarg/sarg.conf 
    dosym /etc/sarg/sarg.conf /usr/share/sarg/sarg.conf
    
    dodoc BETA-TESTERS CONTRIBUTORS DONATIONS README ChangeLog htaccess
    
    exeinto /etc/cron.daily
    doexe ${FILESDIR}/sarg.daily

    exeinto /etc/cron.weekly
    doexe ${FILESDIR}/sarg.weekly

    exeinto /etc/cron.monthly
    doexe ${FILESDIR}/sarg.monthly
    
    insinto /srv/www/sarg
    doins ${FILESDIR}/index.html
}

