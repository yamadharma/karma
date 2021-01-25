# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"

inherit eutils pax-utils  user versionator

DESCRIPTION="Native linux thin client of 1C ERP system"
HOMEPAGE="http://v8.1c.ru/"

MY_PN=1c-enterprise
MY_PV="$(replace_version_separator 3 '-' )"

SRC_URI="${MY_PN}-${PV}-thin-client_${MY_PV}_amd64.deb
	nls? ( ${MY_PN}-${PV}-thin-client-nls_${MY_PV}_amd64.deb )
"
#SRC_URI="${PN}_${MY_PV}_amd64.deb
#	nls? ( ${PN}-nls_${MY_PV}_amd64.deb )
#"

SLOT=$(get_version_component_range 1-2)
LICENSE="1CEnterprise_en"
KEYWORDS="amd64"
RESTRICT="fetch strip"

IUSE="+nls"

RDEPEND="app-arch/dpkg
	sys-libs/zlib"

DEPEND="${RDEPEND}"
RDEPEND="=app-office/1c-enterprise83-thin-client-support-${PV}"

S="${WORKDIR}"

src_unpack() {
	for i in ${A}
	do
	    dpkg-deb -R "${DISTDIR}"/"${i}" ${WORKDIR}
	    rm -rf ${WORKDIR}/DEBIAN
	done
}

src_install() {
	dodir /opt /usr/bin
	cp -R "${WORKDIR}"/opt/* "${D}"/opt
	# mv "${WORKDIR}"/usr/lib/x86_64-linux-gnu/* "${D}"/opt/1C/v8.3/x86_64

	cp -R "${WORKDIR}"/usr/* "${D}"/usr

	#local res
	#for res in 16 22 24 32 36 48 64 72 96 128 192 256; do
	#	for icon in 1cv8c; do
	#		newicon -s ${res} "${WORKDIR}/usr/share/icons/hicolor/${res}x${res}/apps/${icon}.png" "${icon}.png"
	#	done
	#done

	domenu "${WORKDIR}"/usr/share/applications/1cv8c-${MY_PV}.desktop

#	dosym /opt/1C/v8.3/x86_64/1cv8c /usr/bin/1cv8c
	dobin ${FILESDIR}/1cv8c
	sed -i -e "s/@PV@/${PV}/g" "${D}"/usr/bin/1cv8c
}

