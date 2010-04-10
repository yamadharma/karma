# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit webapp depend.php

DESCRIPTION="Moodle is a course management system (CMS)"
HOMEPAGE="http://moodle.org/"
SRC_URI="http://download.moodle.org/stable19/${P}.tgz"

LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE="ldap mysql postgres"

DEPEND=""
RDEPEND="virtual/cron
	virtual/httpd-cgi"

need_php_httpd

S="${WORKDIR}/${PN}"

pkg_setup() {
	local flags="curl iconv ssl sockets tokenizer unicode zlib"
	for i in ldap mysql postgres ; do
		use ${i} && flags="${flags} ${i}"
	done
	if ! PHPCHECKNODIE="yes" require_php_with_use ${flags} || \
		! PHPCHECKNODIE="yes" require_php_with_any_use gd gd-external ; then
			die "Re-install ${PHP_PKG} with ${flags} and either gd or gd-external"
	fi 
	webapp_pkg_setup
}

src_install() {
	webapp_src_preinst
	dodoc README.txt
	dodir ${MY_HOSTROOTDIR}/${PF}

	cp -R . "${D}"${MY_HTDOCSDIR}

	# do webapp_configfile config-dist.php so that users can identify
	# changed default values with ease
	webapp_configfile ${MY_HTDOCSDIR}/config-dist.php

	webapp_serverowned ${MY_HOSTROOTDIR}/${PF}

	webapp_postinst_txt en "${FILESDIR}"/README.gentoo
	webapp_hook_script "${FILESDIR}"/reconfig
	webapp_src_install
}
