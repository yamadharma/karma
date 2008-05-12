# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit bzr distutils eutils

DESCRIPTION="Bazaar plugin which adds support for maintaining a stack of related
threads"
HOMEPAGE="https://launchpad.net/bzr-loom/"
SRC_URI=""
EBZR_REPO_URI="lp:${PN}/"
EBZR_BRANCH="1.3"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=">=dev-util/bzr-1.0_rc1"
RDEPEND=""

src_unpack() {
	bzr_src_unpack
	epatch "${FILESDIR}"/${P}-setup-fix.patch
}
