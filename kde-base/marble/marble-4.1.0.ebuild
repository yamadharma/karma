# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

NEED_KDE="none"
KMNAME=kdeedu
SLOT="4.1" # Goes in the ebuild because of NEED_KDE=none
KDEDIR="/usr/kde/4.1"
CPPUNIT_REQUIRED="optional"
inherit kde4overlay-meta

DESCRIPTION="KDE: generic geographical map widget"
KEYWORDS="~amd64 ~x86"
IUSE="debug designer-plugin htmlhandbook kde gps"
# Need to set this because of NEED_KDE="none"

# FIXME: undefined reference when building tests. RESTRICTed for now.
RESTRICT="test"

COMMONDEPEND="
	gps? ( sci-geosciences/gpsd )
	kde? ( >=kde-base/kdelibs-${PV}:${SLOT}
		>=kde-base/kdepimlibs-${PV}:${SLOT} )"
DEPEND="${COMMONDEPEND}"
RDEPEND="${COMMONDEPEND}"

src_compile() {
	#epatch "${FILESDIR}/marble-4.0.85-to-fixed-svn.patch"

	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with designer-plugin DESIGNER_PLUGIN)"

	if use gps; then
		mycmakeargs="${mycmakeargs} -DHAVE_LIBGPS=1"
	else
		sed -i -e 's:FIND_LIBRARY(libgps_LIBRARIES gps):# LIBGPS DISABLED &:' \
			marble/Findlibgps.cmake || die "sed to disable gpsd failed."
	fi

	if ! use kde; then
		mycmakeargs="${mycmakeargs} -DQTONLY:BOOL=ON"
	fi

	kde4overlay-meta_src_compile
}

src_install() {
	kde4overlay-meta_src_install
	rm "${D}/usr/kde/4.1/share/apps/cmake/modules/FindKDEEdu.cmake"
}

src_test() {
	mycmakeargs="${mycmakeargs} -DENABLE_TESTS=TRUE"
	kde4overlay-meta_src_test
}
