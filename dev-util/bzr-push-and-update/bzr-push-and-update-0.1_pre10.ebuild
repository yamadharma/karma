# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit python bzr

DESCRIPTION="Run 'ssh remote bzr update path' after pushing to sftp://remote/path"
HOMEPAGE="https://launchpad.net/bzr-push-and-update"
EBZR_REPO_URI="lp:///~bzr/bzr-push-and-update/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="${DEPEND}"
RDEPEND="${RDEPEND}"

S="${WORKDIR}"/${P}

pkg_setup() {
	export EBZR_REVISION=`echo "${PV}" | sed -e 's:^.\+_pre\(.*\)$:\1:g' `
}

src_unpack() {
	bzr_src_unpack
}

src_install() {
	python_version
	insinto /usr/lib/python${PYVER}/site-packages/bzrlib/plugins/push-and-update
	doins *.py
}
