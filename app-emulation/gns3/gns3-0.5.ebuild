# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild come from http://code.gns3.net/hgwebdir.cgi/gns3-overlay/summary

inherit eutils multilib python distutils

MY_P="${P/gns3/GNS3}"

DESCRIPTION="A graphical frontend to dynamips"
HOMEPAGE="http://www.gns3.net/"
SRC_URI="mirror://sourceforge/gns-3/${MY_P}-src.tar.bz2
	http://www.gns3.net/files/release/${PV}/${MY_P}-src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="${DEPEND}"
RDEPEND="${RDEPEND}
	>=x11-libs/qt-4.3
	>=dev-python/PyQt4-4.3
	>=app-emulation/dynamips-0.2.8_rc1"

PYTHON_MODNAME="GNS3"
S="${WORKDIR}/${MY_P}-src"

src_install() {
	distutils_src_install
	doman docs/man/gns3.1 || die "doman failed"
}
