# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/cfengine/cfengine-2.1.18.ebuild,v 1.3 2006/02/27 17:38:15 gustavoz Exp $

inherit eutils

DESCRIPTION="An agent/software robot and a high level policy language for building expert systems to administrate and configure large computer networks"
HOMEPAGE="http://www.iu.hio.no/cfengine/"
SRC_URI="ftp://ftp.iu.hio.no/pub/cfengine/${P/_p/p}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc sparc x86"
IUSE=""

S=${WORKDIR}/${P/_p/p}

DEPEND=">=sys-libs/db-3.2
	>=dev-libs/openssl-0.9.7"

src_compile() {
	# Enforce /var/lib/cfengine for historical compatibility
	econf \
		--with-workdir=/var/lib/cfengine \
		--with-berkeleydb=/usr || die

	# Fix Makefile to skip doc,inputs, & contrib install to wrong locations
	sed -i -e 's/\(DIST_SUBDIRS.*\) contrib inputs doc/\1/' Makefile
	sed -i -e 's/\(SUBDIRS.*\) contrib inputs/\1/' Makefile
	sed -i -e 's/\(install-data-am.*\) install-docDATA/\1/' Makefile

	emake || die
}

src_install() {
	newinitd "${FILESDIR}"/cfservd.rc6 cfservd

	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog README TODO INSTALL

	# Manually install doc and inputs
	doinfo doc/*.info*
	dohtml doc/*.html
	doman doc/*.8
	dodoc ${FILESDIR}/cfportage.README
	docinto examples
	dodoc inputs/*.example

	# Create cfengine working directory
	mkdir -p ${D}/var/lib/cfengine
	fperms 700 /var/lib/cfengine
	keepdir /var/lib/cfengine/bin
	keepdir /var/lib/cfengine/inputs
	dodir /var/lib/cfengine/modules
	tar jxf ${FILESDIR}/module-cfportage.tbz2 -C ${D}/var/lib/cfengine/modules
	fowners root:0 /var/lib/cfengine/modules/module\:cfportage
	
	dosym /var/lib/cfengine /var/cfengine

}

pkg_postinst() {
	if [ ! -f "/var/lib/cfengine/ppkeys/localhost.priv" ]
		then
		einfo "Generating keys for localhost."
		/usr/sbin/cfkey
	fi


	# Copy cfagent into the cfengine tree otherwise cfexecd won't
	# find it. Most hosts cache their copy of the cfengine
	# binaries here. This is the default search location for the
	# binaries.

	cp /usr/sbin/cf{agent,servd,execd} /var/lib/cfengine/bin/

	einfo
	einfo "Now an init script for cfservd is provided."
	einfo
	einfo "To run cfengine out of cron every half hour modify your crontab:"
	einfo "0,30 * * * *    /usr/sbin/cfexecd -F"
	einfo
}
