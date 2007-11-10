# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit python bzr

DESCRIPTION="Plugin that provides integration between bzr and D-Bus."
HOMEPAGE="https://launchpad.net/bzr-dbus"
EBZR_REPO_URI="lp:///~bzr/bzr-vimdiff/"
EBZR_BRANCH="vimdiff"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="${DEPEND}"
RDEPEND="${DEPEND}
	|| (
		app-editors/vim
		app-editors/gvim
	)"
S="${WORKDIR}"/${P}

pkg_setup() {
	export EBZR_REVISION=`echo "${PV}" | sed -e 's:^.\+_pre\(.*\)$:\1:g' `
}

src_install() {
	python_version
	insinto /usr/lib/python${PYVER}/site-packages/bzrlib/plugins/vimdiff
	doins __init__.py
	dodoc README
}
