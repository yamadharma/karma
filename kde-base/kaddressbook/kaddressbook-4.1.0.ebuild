# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

KMNAME=kdepim
inherit kde4overlay-meta

DESCRIPTION="The KDE Address Book"
KEYWORDS="~amd64 ~x86"
IUSE="debug gnokii htmlhandbook"

DEPEND=">=kde-base/libkdepim-${PV}:${SLOT}
	>=kde-base/libkleo-${PV}:${SLOT}
	gnokii? ( app-mobilephone/gnokii )"
RDEPEND="${DEPEND}"

KMLOADLIBS="libkdepim libkleo"

# xml targets from kmail are being uncommented by kde4overlay-meta.eclass
KMEXTRACTONLY="kmail/
	libkdepim/
	libkleo/"

src_compile(){
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with gnokii GNOKII)"

	kde4overlay-meta_src_compile
}
