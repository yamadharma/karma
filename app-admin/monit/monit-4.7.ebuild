# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="a utility for monitoring and managing daemons or similar programs running on a Unix system."
HOMEPAGE="http://www.tildeslash.com/monit/"
SRC_URI="http://www.tildeslash.com/monit/dist/${P}.tar.gz
	http://www.tildeslash.com/monit/dist/${P}.patch01"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ~ppc ~sparc"
IUSE="ssl"

RDEPEND="virtual/libc
	ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}
	sys-devel/flex
	sys-devel/bison"

src_unpack() {
	unpack ${A}
	
	cd ${S}
	epatch ${DISTDIR}/${P}.patch01 || die
}

src_compile() {
	econf `use_with ssl` || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die

	dodoc CHANGES.txt CONTRIBUTORS FAQ.txt README* STATUS UPGRADE.txt
	dohtml -r doc/*
	dodoc monitrc 

	insinto /etc; insopts -m700; doins ${FILESDIR}/monitrc || die
	tar -xj -C ${D}/etc -f ${FILESDIR}/monitrc.d.tar.bz2

	newinitd "${FILESDIR}"/monit.initd monit || die
}

pkg_postinst() {
	einfo "Sample configurations are available at"
	einfo "http://www.tildeslash.com/monit/examples.html"
}
