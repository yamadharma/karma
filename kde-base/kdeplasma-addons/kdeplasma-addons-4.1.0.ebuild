# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

#KMNAME=kdeplasmoids
OPENGL_REQUIRED="optional"
inherit kde4overlay-base

PREFIX="${KDEDIR}"

DESCRIPTION="Extra Plasma applets and engines."
HOMEPAGE="http://www.kde.org/"
LICENSE="GPL-2 LGPL-2"

KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="!kde-misc/extragear-plasma:${SLOT}
	!kde-base/kdeplasmoids:${SLOT}
	>=kde-base/qimageblitz-0.0.4
	>=kde-base/krunner-${PV}:${SLOT}
	>=kde-base/libtaskmanager-${PV}:${SLOT}
	>=kde-base/libplasma-${PV}:${SLOT}
	>=kde-base/plasma-workspace-${PV}:${SLOT}
	opengl? ( virtual/opengl )"
RDEPEND="${DEPEND}"

src_compile() {
	# Dir doesn't exist
	sed -e '/tutorial/d' \
		-i "${S}"/applets/CMakeLists.txt \
		|| die "Removing tutorial line failed."
	mycmakeargs="${mycmakeargs}
		-DDBUS_INTERFACES_INSTALL_DIR=${KDEDIR}/share/dbus-1/interfaces/
		$(cmake-utils_use_with opengl OpenGL)"
	kde4overlay-base_src_compile
}
