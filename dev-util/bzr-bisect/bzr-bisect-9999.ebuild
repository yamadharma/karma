# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EBZR_REPO_URI="lp:bzr-bisect"

inherit distutils bzr

DESCRIPTION="Bazaar plugin that finds when source code was introduced into a
branch via a binary search."
HOMEPAGE="https://launchpad.net/bzr-bisect/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=""
RDEPEND=">=dev-util/bzr-0.18_rc1"
