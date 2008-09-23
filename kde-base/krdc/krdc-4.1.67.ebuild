# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

KMNAME=kdenetwork
inherit kde4overlay-meta

DESCRIPTION="KDE remote desktop connection (RDP and VNC) client"
KEYWORDS="x86 amd64"
IUSE="debug htmlhandbook jpeg vnc zeroconf nx"

DEPEND="
	nx? ( >=net-misc/nxcl-0.9-r1 )
	jpeg? ( media-libs/jpeg )
	vnc? ( >=net-libs/libvncserver-0.9 )
	zeroconf? ( || ( net-dns/avahi net-misc/mDNSResponder ) )"
RDEPEND="${DEPEND}"

PATCHES="${FILESDIR}/krdc-nxcl.patch"

src_compile() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with jpeg JPEG)
		$(cmake-utils_use_with vnc LibVNCServer)
		$(cmake-utils_use_with zeroconf DNSSD)"
	kde4overlay-meta_src_compile
	sed -e '72,74d' -i ${WORKDIR}/krdc_build/krdc/cmake_install.cmake || die "sed failed" #nomachine default key isnt there, doesnt matter	
}
