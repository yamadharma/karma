# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Bazaar plugin that adds support for foreign Subversion repositories."
HOMEPAGE="http://bazaar-vcs.org/BzrForeignBranches/Subversion"
SRC_URI="http://samba.org/~jelmer/bzr/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=">=dev-util/bzr-0.92_rc1
	|| ( >=dev-lang/python-2.5 >=dev-python/pysqlite-2 )
	dev-util/subversion"
RDEPEND=""

pkg_setup() {
	if ! built_with_use dev-util/subversion python; then
		eerror "${PN} requires the python bindings for dev-util/subversion"
		eerror "(USE=python)"
		die
	fi
	elog "Please make sure that you've installed dev-util/subversion"
	elog "from the same overlay as this ebuild."
}
