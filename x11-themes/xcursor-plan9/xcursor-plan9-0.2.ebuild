# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Xorg cursor theme inspired and based on plan9 cursors"
HOMEPAGE="https://xn--1xa.duncano.de/"
SRC_URI="https://π.duncano.de/files/${P}.tar.xz"
S="${WORKDIR}/plan9"

LICENSE="unknown"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86"

DEPEND="x11-apps/xcursorgen"
RDEPEND="x11-libs/libXcursor"


src_install() {
	insinto /usr/share/icons/plan9
	doins index.theme cursor.theme

	insinto /usr/share/icons/plan9/cursors
	doins -r cursors/.

	dosym /usr/share/icons/plan9/cursors /usr/share/cursors/xorg-x11/plan9
}
