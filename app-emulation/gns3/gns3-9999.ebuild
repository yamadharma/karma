# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild come from http://code.gns3.net/hgwebdir.cgi/gns3-overlay/summary

inherit eutils multilib python distutils mercurial

DESCRIPTION="A graphical frontend to dynamips"
HOMEPAGE="http://www.gns3.net/"

EHG_REPO_URI="http://www.gns3.net/hg/gns3-devel"
S="${WORKDIR}/gns3-devel"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="${DEPEND}"
RDEPEND="${RDEPEND}
		>=x11-libs/qt-4.3
		>=dev-python/PyQt4-4.3
		>=app-emulation/dynamips-0.2.8_rc1"

PYTHON_MODNAME="GNS3"

src_unpack() {
	mercurial_src_unpack
}

src_compile() {
	distutils_src_compile
}

src_install() {
	distutils_src_install
	doman docs/man/gns3.1 || die "doman failed"
}
