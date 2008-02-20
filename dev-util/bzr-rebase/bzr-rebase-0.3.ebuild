# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Bazaar plugin that adds support for rebasing, similar to \
functionality in git."
HOMEPAGE="http://bazaar-vcs.org/Rebase"
SRC_URI="http://samba.org/~jelmer/bzr/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=">=dev-util/bzr-0.92"
RDEPEND=""

S="${WORKDIR}"/${P}
