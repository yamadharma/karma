# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit distutils

DESCRIPTION="Support for Git branches in Bazaar"
HOMEPAGE="http://bazaar-vcs.org/BzrForeignBranches/Git"
SRC_URI="http://samba.org/~jelmer/bzr/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

# Check info.py for dulwich and bzr version dependency info.
# The file should be fairly straightforward to understand.
DEPEND=""
RDEPEND=">=dev-python/dulwich-0.5.0
	>=dev-vcs/bzr-1.15_rc1"
