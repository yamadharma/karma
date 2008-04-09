# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit depend.php eutils
DESCRIPTION="PHP General Access Control List"
HOMEPAGE="http://phpgacl.sourceforge.net"
SRC_URI="http://ovh.dl.sourceforge.net/sourceforge/phpgacl/phpgacl-3.3.7.tar.gz" #Исправили на более новую
LICENSE="LGPL"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="mysql postgres docs examples apache2"
DEPEND=""
RDEPEND="mysql? ( >=dev-db/mysql-4.0.15 )
	postgres? ( >=dev-db/postgresql-7.2 )
	dev-php/adodb"
	
pkg_setup() {
	if ((!(use mysql)) && (!(use postgres))); then
	    die "phpGACL needs either MySQL or PostgreSQL to be installed."
	fi
}

src_install() {
	P_DIR="/usr/share/php/${PN}"
	PREFIX="/usr/share"
	
	insinto ${P_DIR}
	doins *.php *.inc *.ini *.xml
	dodoc AUTHORS CHANGELOG COPYING.lib CREDITS FAQ README TODO
	
	cd ${S}/Cache_Lite
	insinto ${P_DIR}/Cache_Lite
	doins *.php
	docinto ${PREFIX}/doc/${P}/Cache_Lite/info
	dodoc LICENSE
	
	cd ${S}/admin
	insinto ${P_DIR}/admin
	doins *.php *.gif *.js *.css
	cd ${S}/admin/images
	insinto ${P_DIR}/admin/images
	doins *
	cd ${S}/admin/smarty
	docinto ${PREFIX}/doc/${P}/smarty/info
	dodoc README
	dirs="libs libs/core libs/internals libs/plugins"
	for i in ${dirs}; do
	    cd ${S}/admin/smarty/${i}
	    insinto ${P_DIR}/admin/smarty/${i}
	    doins *
	done
	cd ${S}/admin/templates/phpgacl
	insinto ${P_DIR}/admin/templates/phpgacl
	doins *.tpl
	dodir ${P_DIR}/admin/templates_c
	
	cd ${S}
	if (use docs); then
	    if (use examples); then
		dirs="docs docs/examples docs/examples/millennium_falcon docs/phpdoc docs/phpdoc/media
		docs/phpdoc/media/images docs/phpdoc/phpGACL docs/tarnslations/russian"
	    else
		dirs="docs docs/phpdoc docs/phpdoc/media docs/phpdoc/media/images docs/phpdoc/phpGACL 
		docs/tarnslations/russian"
	    fi
	    for i in ${dirs}; do
		insinto ${P_DIR}/admin/smarty/${i}
		doins *
	    done
	fi
	
	cd ${S}/soap
	insinto ${P_DIR}/soap
	doins *
	cd ${S}/soap/clients
	insinto ${P_DIR}/soap/clients
	doins *
	
	cd ${S}/test_suite
	insinto ${P_DIR}/test_suite
	doins *
	cd ${S}/test_suite/phpunit
	insinto ${P_DIR}/test_suite/phpunit
	doins *.php *.css
	docinto ${PREFIX}/doc/${P}/test_suite/info
	dodoc ChangeLog README
	dosym /usr/share/php/adodb ${P_DIR}/adodb
	
	targ=""
	if (use apache2); then
	    targ="etc/apache2/vhosts.d"
	else
	    targ="etc/apache/vhosts.d"
	fi
	insinto ${targ}
	doins ${FILESDIR}/${PN}.conf || die "Cannot install virtual host for phpGACL. Check if ${PN}.conf is exist in ${FILESDIR}" 
}
