# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit gnustep-base apache-module

MY_PV="1621-200805211100"

DESCRIPTION="an extensive set of frameworks which form a complete Web application server environment"
HOMEPAGE="http://sope.opengroupware.org/en/index.html"
SRC_URI="http://download.opengroupware.org/nightly/sources/trunk/${PN}-trunk-r${MY_PV}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="mysql +postgres sqlite"

DEPEND="gnustep-base/gnustep-base
	dev-libs/libxml2
	net-nds/openldap
	mysql? ( virtual/mysql )
	postgres? ( virtual/postgresql-base )
	sqlite? ( >=dev-db/sqlite-3 )"
RDEPEND="${DEPEND}"

APACHE2_MOD_DEFINE="SOPE"
APACHE2_MOD_FILE="sope-appserver/mod_ngobjweb/mod_ngobjweb.so"
need_apache2

S=${WORKDIR}/${PN}

src_unpack() {
	gnustep-base_src_unpack

	# Fix for recent gnustep-base
	epatch "${FILESDIR}"/${PN}-nsexception.patch
	# Install in System instead of Local
	epatch "${FILESDIR}"/${PN}-use_system_root.patch
	# From SOGo project
	epatch "${FILESDIR}"/${PN}-gsmake2.diff
	epatch "${FILESDIR}"/${PN}-mime-nosort.diff
	epatch "${FILESDIR}"/${PN}-patchset-r1621.diff
}

src_compile() {
	# Do not use standard src_compile, as ./configure is not standard
	egnustep_env
	./configure --with-gnustep || die "configure failed"
	egnustep_make apxs=/usr/sbin/apxs apr=/usr/bin/apr-1-config
}

src_install() {
	gnustep-base_src_install
	apache-module_src_install
}

pkg_postinst() {
	gnustep-base_pkg_postinst
	apache-module_pkg_postinst
}
