# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

KMNAME=kdeedu
inherit kde4overlay-meta

DESCRIPTION="KDE Educational: vocabulary trainer"
KEYWORDS="~amd64 ~x86"
IUSE="debug htmlhandbook +plasma"

COMMONDEPEND=">=kde-base/libkdeedu-${PV}:${SLOT}
	plasma? ( kde-base/libplasma:${SLOT} )"
DEPEND="${COMMONDEPEND}"
RDEPEND="${COMMONDEPEND}"

KMEXTRACTONLY="libkdeedu/keduvocdocument"

src_compile() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with plasma Plasma)"
	kde4overlay-meta_src_compile
}
