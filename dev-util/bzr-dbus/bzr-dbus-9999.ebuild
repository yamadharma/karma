# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit bzr distutils

DESCRIPTION="Plugin that provides integration between bzr and D-Bus."
HOMEPAGE="https://launchpad.net/bzr-dbus"
EBZR_REPO_URI="lp:bzr-dbus"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="${DEPEND}"
RDEPEND="dev-python/dbus-python
	dev-python/pygobject"
S="${WORKDIR}"/${P}

src_unpack() {
	bzr_src_unpack
}
