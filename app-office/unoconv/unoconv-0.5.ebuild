# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2"
inherit eutils python

DESCRIPTION="Convert between any document format supported by OpenOffice"
HOMEPAGE="http://dag.wieers.com/home-made/unoconv/"
SRC_URI="http://dag.wieers.com/home-made/unoconv/${P}.tar.bz2"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
IUSE=""

SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
	!app-text/odt2txt
	virtual/ooo
"


pkg_setup() {
	python_set_active_version 2
}

src_prepare() {
#	epatch "${FILESDIR}/fix_empty_ld_path.patch"
#	epatch "${FILESDIR}/fix_libreoffice_support.patch"
	epatch "${FILESDIR}/timeout.patch"

	python_convert_shebangs -r 2 .
}

src_compile() { :; }

src_install() {
	emake docs DESTDIR="${D}"
	emake docs-install DESTDIR="${D}"
	emake install DESTDIR="${D}"
	emake install-links DESTDIR="${D}"
}
