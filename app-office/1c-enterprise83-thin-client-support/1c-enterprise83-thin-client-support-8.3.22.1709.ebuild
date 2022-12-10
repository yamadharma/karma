    # Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="7"

inherit eutils pax-utils

DESCRIPTION="Support libs for Native linux thin client of 1C ERP system"
HOMEPAGE="http://v8.1c.ru/"

SRC_URI="
	mirror://debian/pool/main/w/webkitgtk/libwebkitgtk-3.0-0_2.4.11-3_amd64.deb
	mirror://debian/pool/main/w/webkitgtk/libjavascriptcoregtk-3.0-0_2.4.11-3_amd64.deb
	mirror://debian/pool/main/libw/libwebp/libwebp6_0.6.1-2.1_amd64.deb
	mirror://debian/pool/main/i/icu/libicu57_57.1-6+deb9u4_amd64.deb
"

SLOT=$(ver_cut 1-2)
LICENSE="misc"
KEYWORDS="amd64"
RESTRICT="strip"

IUSE="+nls"

RDEPEND="app-arch/dpkg
	sys-libs/zlib"

DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_unpack() {
	for i in ${A}
	do
	    dpkg-deb -R "${DISTDIR}"/"${i}" ${WORKDIR}
	    rm -rf ${WORKDIR}/DEBIAN
	done
}

src_install() {
	dodir /opt/1cv8/x86_64/${PV}
	mv "${WORKDIR}"/usr/lib/x86_64-linux-gnu/* "${D}"/opt/1cv8/x86_64/${PV}
}

