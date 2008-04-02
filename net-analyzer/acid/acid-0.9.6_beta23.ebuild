# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /tmp/ebuilds/acid-0.9.6_beta23.ebuild,v 1.0 2004/04/19 14:48:10 jasmine Exp $

inherit eutils

DESCRIPTION="SNORT ACID - Analysis Console for Intrusion Databases"
HOMEPAGE="http://acidlab.sourceforge.net"
SRC_URI="http://acidlab.sourceforge.net/${PN}-0.9.6b23.tar.gz"
IUSE="apache2 php5 mysql postgres" 
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
DEPEND="apache2? ( >=www-servers/apache-2.0.0 ) !apache2? ( >=www-servers/apache-1.3.0 )
	mysql? ( >=dev-db/mysql-3.23.0 )
	postgres? ( >=dev-db/postgres-7.0)
	>=dev-php/adodb-1.2
	php5? ( >=dev-lang/php-5.0 ) !php5? ( >=dev-lang/php-4.0.4 )
	>=net-analyzer/snort-1.7
	>=my/logsnorter-0.2
	
	php5? ( >=dev-php5/jpgraph-1.8 ) !php5? ( >=dev-php4/jpgraph-1.8 )
	>=my/phplot-4.4.6
	>=media-libs/gd-1.8.0"
	
S=${WORKDIR}/${PN}

# NOTE that adodb and jpgraph are unstable packages 

pkg_install () {
	if (!mysql) &&  (!postgres); then 
	    die "MySQL or PostgreSQL database is required for ACID."
	fi
}

src_install () {
	epatch ${FILESDIR}/acid-0.9.6_beta23.diff
	insinto /var/www/acid
	doins *.php *.inc *.css *.html *.sql
	if (use apache2); then
	    insinto /etc/apache2/vhosts.d
	    doins ${FILESDIR}/acid.conf
	else
	    insinto /etc/apache/vhosts.d
	    doins ${FILESDIR}/acid.conf
	fi
	dodoc CHANGELOG CREDITS README TODO
}
pkg_postinst() {
	einfo 
	einfo "This script puts ACID files into the default"
	einfo "root directory of your web server. Remember that"
	einfo "the ACID database is an extension of the Snort" 
	einfo "database. To setup ACID database read the README."
	einfo 
}

