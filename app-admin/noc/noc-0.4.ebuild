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
	dev-python/django
	dev-python/jinja
	dev-python/pygments
	>=dev-db/postgresql-server-8.1
	dev-python/setuptools
	dev-python/psycopg:2
	dev-python/south
	dev-libs/protobuf
	dev-python/sphinx
	dev-python/flup
	net-libs/libsmi
	>=dev-python/pysnmp-4.1
	dev-python/pyasn1
	net-analyzer/fping
	net-misc/rsync
	dev-python/python-creole
	dev-python/netifaces
	net-dns/bind-tools
	dev-vcs/mercurial
	|| ( net-misc/telnet-bsd net-misc/netkit-telnetd )"

pkg_setup() {
	enewgroup noc
	enewuser noc -1 -1 /opt/noc noc
}


pkg_config() {
	su - postgres
		createuser -D -I -S -R noc
		createdb -EUTF8 -Onoc noc
	exit
	
	#su - noc
	cd /opt/noc
	./scripts/post-update
	
	python manage.py syncdb 
	python manage.py migrate
	#exit
}

