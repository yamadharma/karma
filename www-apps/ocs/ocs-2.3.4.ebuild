# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=2

inherit webapp eutils depend.php


DESCRIPTION="Open Conference Systems"
HOMEPAGE="http://pkp.sfu.ca/ocs"
SRC_URI="http://pkp.sfu.ca/ocs/download/${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
IUSE=""

need_httpd_cgi
need_php_httpd

# S="${WORKDIR}/${P/_/-}"

pkg_setup() {
	flags=""
	webapp_pkg_setup
	has_php
	require_php_with_use ${flags}
}

src_install() {
	webapp_src_preinst

	local docs="docs/release-notes/* docs/*"
	dodoc ${docs}

	insinto "${MY_HTDOCSDIR}"
	doins -r .
	webapp_serverowned "${MY_HTDOCSDIR}"/cache

	webapp_src_install

	doenvd ${FILESDIR}/99ocs
}
