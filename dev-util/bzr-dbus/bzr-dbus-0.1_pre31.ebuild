# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Plugin that provides integration between bzr and D-Bus."
HOMEPAGE="https://launchpad.net/bzr-dbus"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="${DEPEND}"
RDEPEND="dev-python/dbus-python
	dev-python/pygobject"
S="${WORKDIR}"/${PN}

src_install() {
	distutils_src_install
	insinto /usr/share/dbus-1/services
	doins org.bazaarvcs.plugins.dbus.Broadcast.service
}
