# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

MY_P=${P/_rc/~rc}

DESCRIPTION="Bazaar plugin that adds support for foreign Subversion repositories."
HOMEPAGE="http://bazaar-vcs.org/BzrForeignBranches/Subversion"
SRC_URI="http://samba.org/~jelmer/bzr/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=">=dev-util/bzr-1.9_rc1
	|| ( >=dev-lang/python-2.5 >=dev-python/pysqlite-2 )
	>=dev-libs/apr-1
	>=dev-util/subversion-1.4.0"
RDEPEND=""

S="${WORKDIR}"/${MY_P}
