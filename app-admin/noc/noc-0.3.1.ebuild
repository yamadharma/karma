# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit distutils eutils

DESCRIPTION="NOC Project is an Operation Support System (OSS)"
HOMEPAGE="http://trac.nocproject.org"
SRC_URI="http://trac.nocproject.org/trac/downloads/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=dev-lang/python-2.5
	>=virtual/postgresql-server-8.1
	dev-python/setuptools
	dev-python/psycopg:2
	dev-python/south
	dev-libs/protobuf
	dev-python/sphinx
	dev-python/flup
	net-libs/libsmi
	>=dev-python/pysnmp-4*
	dev-python/pyasn1
	net-analyzer/fping
	net-misc/rsync
	dev-python/python-creole
	dev-python/netifaces"

