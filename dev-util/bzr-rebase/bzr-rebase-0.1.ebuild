# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Bazaar plugin that adds support for rebasing, similar to \
functionality in git."
HOMEPAGE="http://bazaar-vcs.org/Rebase"
SRC_URI="http://samba.org/~jelmer/bzr/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="dev-util/bzr"
RDEPEND=""

S="${WORKDIR}"/${PN}-${PV}.orig
