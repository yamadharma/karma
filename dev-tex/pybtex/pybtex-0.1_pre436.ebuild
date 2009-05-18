# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit distutils bzr

DESCRIPTION="BibTeX-compateble bibliography processor in Python"
HOMEPAGE="https://launchpad.net/ami/pybtex"
EBZR_REPO_URI="lp:///~ero-sennin/${PN}/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE=""
DEPEND=""

pkg_setup() {
	export EBZR_REVISION=`echo "${PV}" | sed -e 's:^.\+_pre\(.*\)$:\1:g' `
}

src_install() {
	distutils_src_install
	cp -R ${S}/examples ${D}/usr/share/doc/${PF}
}