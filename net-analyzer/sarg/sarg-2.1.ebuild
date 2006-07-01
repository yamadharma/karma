# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/sarg/sarg-2.1.ebuild,v 1.1 2006/01/08 15:22:15 pva Exp $

inherit eutils

DESCRIPTION="Squid Analysis Report Generator"
HOMEPAGE="http://sarg.sourceforge.net/sarg.php"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"
IUSE=""
DEPEND="media-libs/gd"

HTMLDIR=/srv/localhost/www/sarg

pkg_setup() {
	built_with_use -a media-libs/gd png || die \
	"Please recompile media-libs/gd with USE=\"png\""
}

src_unpack() {
	unpack ${A}
	cd ${S}

	# Fixes bug #43132
	sed -i \
	-e 's:"/usr/local/squid/var/logs/access.log":"/var/log/squid/access.log":' \
	-e 's:"/usr/local/etc/httpd/htdocs/squid-reports":"/srv/localhost/www/sarg/sarg":' \
	log.c || die "setting default for gentoo directories... failed"

	sed -i \
	-e 's:/usr/local/squid/var/logs/access.log:/var/log/squid/access.log:' \
	-e 's:/var/www/html/squid-reports:$HTMLDIR/sarg:' \
	sarg.conf || die "setting default for gentoo directories... failed"

	# Fixes bug #64743
	sed -i -e 's:sarg_tmp:sarg:' email.c || die "fixing dir in email.c failed"

	sed -i \
	-e 's:/usr/local/sarg/sarg.conf:/etc/sarg/sarg.conf:' \
	-e 's:/usr/local/squid/logs/access.log:/var/log/squid/logs/access.log:' \
	sarg.1 || die "Failed to fix man page."

	epatch ${FILESDIR}/sarg-2.1-datafile.patch
	epatch ${FILESDIR}/sarg-2.1-laslog.patch
}

src_compile() {
	econf \
		--enable-bindir=/usr/bin \
		--enable-mandir=/usr/share/man/man1 \
		--enable-htmldir=${HTMLDIR} \
		--enable-sysconfdir=/usr/share/sarg \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	# This is workaround for sarg installation script, which do not creat dirs.
	dodir /etc/sarg /usr/sbin /usr/share/sarg ${HTMLDIR}


	make \
		BINDIR=${D}/usr/sbin \
		MANDIR=${D}/usr/share/man/man1 \
		SYSCONFDIR=${D}/usr/share/sarg \
		HTMLDIR=${D}/${HTMLDIR} \
		install || die "sarg installation failed"

	dodoc BETA-TESTERS CONTRIBUTORS DONATIONS README ChangeLog htaccess

	mv ${D}/usr/share/sarg/sarg.conf ${D}/etc/sarg/sarg.conf 
	dosym /etc/sarg/sarg.conf /usr/share/sarg/sarg.conf
		
	dodoc BETA-TESTERS CONTRIBUTORS DONATIONS README ChangeLog htaccess
	
	insinto ${HTMLDIR}
	doins ${FILESDIR}/index.html
	
	exeinto /etc/cron.daily
        doexe ${FILESDIR}/sarg.daily

	exeinto /etc/cron.weekly
        doexe ${FILESDIR}/sarg.weekly

	exeinto /etc/cron.monthly
        doexe ${FILESDIR}/sarg.monthly
}
