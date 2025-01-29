# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="8"

inherit pax-utils

DESCRIPTION="ZTN Client for Linux"
HOMEPAGE=""

MY_PN=${PN}
MY_PV="$(ver_cut 1-3)-$(ver_cut 4).ks1"

SRC_URI="${PN}-${MY_PV}_amd64.deb"
#SRC_URI="${P}.tar.gz"

SLOT=$(ver_cut 1-3)
LICENSE="1CEnterprise_en"
KEYWORDS="amd64"
RESTRICT="fetch strip"

IUSE="+nls"

RDEPEND="app-arch/dpkg
	sys-libs/zlib"

DEPEND="${RDEPEND}"
#RDEPEND="=app-office/1c-enterprise83-thin-client-support-${PV}"
RDEPEND=""

S="${WORKDIR}"

src_unpack() {
	for i in ${A}
	do
		dpkg-deb -R "${DISTDIR}"/"${i}" ${WORKDIR}
		rm -rf ${WORKDIR}/DEBIAN
	done
}

src_install() {
	cp -R "${WORKDIR}"/* "${D}"/

	mkdir -p "${D}"/usr/share/doc/${P}
	mv "${D}"/usr/share/doc/{cts,ztn} "${D}"/usr/share/doc/${P}

	# find "${D}"/opt -name "libstdc++.so.6" -delete

	# newbin ${FILESDIR}/1cv8c 1cv8c-${PV}
	# sed -i -e "s/@PV@/${PV}/g" "${D}"/usr/bin/1cv8c-${PV}
}
