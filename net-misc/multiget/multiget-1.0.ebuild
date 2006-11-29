# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_PN="${PN/m/M}"
MY_PN="${MY_PN/g/G}"
MY_PN="${MY_PN/-bin/}"
MY_P="${MY_PN}-${PV}"


DESCRIPTION="A multi thread download tool liked flashget based wxGTK"
HOMEPAGE="http://sourceforge.net/projects/multiget"
SRC_URI="mirror://sourceforge/multiget/${PN}${PV}.src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"

DEPEND=">=x11-libs/wxGTK-2.6.3
	!net-misc/multiget-bin"
RDEPEND="${DEPEND}"

RESTRICT="primaryuri"

S=${WORKDIR}/${PN}${PV}/src

src_compile() {
	cd ${S}
	emake || die "make failed"
}

src_install() {
	cd ${S}
	dobin MultiGet
	insinto /usr/share/applications
	doins ${FILESDIR}/multiget.desktop
	insinto /usr/share/pixmaps
	doins ${FILESDIR}/multiget.png
}
