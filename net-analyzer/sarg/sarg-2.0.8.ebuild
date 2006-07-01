# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

inherit eutils

DESCRIPTION="Sarg (Squid Analysis Report Generator) is a tool that allows you to view where your users are going to on the Internet."
HOMEPAGE="http://sarg.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="virtual/libc
		media-libs/freetype
		media-libs/libpng
		sys-libs/zlib
		media-libs/gd"

RDEPEND=">=net-proxy/squid-2.5.1"

HTMLDIR=/srv/localhost/www/sarg

pkg_setup() {
	built_with_use -a media-libs/gd png truetype || die \
	"Please, recompile media-libs/gd with USE=\"+png +truetype\""
}

src_unpack() {
	unpack ${A}
	cd ${S}
	
	# Fixes bug #43132
	sed -i \
	-e 's:"/usr/local/squid/var/logs/access.log":"/var/log/squid/access.log":' \
	-e "s:/usr/local/etc/httpd/htdocs/squid-reports:$HTMLDIR:" \
	log.c || die "setting default for gentoo directories... failed"
	
	sed -i \
	-e 's:/usr/local/squid/var/logs/access.log:/var/log/squid/access.log:' \
	-e "s:/var/www/html/squid-reports:$HTMLDIR:" \
	sarg.conf || die "setting default for gentoo directories... failed"
	
	# Fixes bug #64743
	sed -i -e 's:sarg_tmp:sarg:' email.c || die "fixing dir in email.c failed"

	sed -i \
	-e 's:/usr/local/sarg/sarg.conf:/etc/sarg/sarg.conf:' \
	-e 's:/usr/local/squid/logs/access.log:/var/log/squid/logs/access.log:' \
	sarg.1 || die "Failed to fix man page."
}

src_compile() {
	rm -rf config.cache
	
	econf \
		--enable-bindir=/usr/bin \
		--enable-mandir=/usr/share/man/man1 \
		--enable-sysconfdir=/usr/share/sarg \
		--enable-htmldir=${HTMLDIR} \
		|| die "./configure failed"
	
	emake || die "compilation failed."
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

