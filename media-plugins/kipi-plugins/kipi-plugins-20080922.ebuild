# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

KMNAME="extragear/graphics"
# NEED_KDE="4.2"
OPENGL_REQUIRED="optional"

inherit kde4-base eutils

ESVN_REPO_URI="svn://anonsvn.kde.org/home/kde/trunk/extragear/graphics/${PN}@{${PV}}"

DESCRIPTION="Plugins for the KDE Image Plugin Interface (libkipi)."
HOMEPAGE="http://www.kipi-plugins.org"

LICENSE="GPL-2"
KEYWORDS="x86 amd64"
IUSE="scanner"
SLOT="4.2"

# TODO: Check deps
DEPEND="
	kde-base/libkdcraw:${SLOT}
	kde-base/libkexiv2:${SLOT}
	kde-base/libkipi:${SLOT}
	media-libs/jpeg
	media-libs/libpng
	>=media-libs/tiff-3.5
	scanner? ( media-gfx/sane-backends
		kde-base/libksane:${SLOT} )
	"

RDEPEND="${DEPEND}"
# app-cdr/k3b: Burning support
# media-gfx/imagemagick: Handle many image formats
# media-video/mjpegtools: Multi image jpeg support

# Install to KDEDIR to slot the package
PREFIX="${KDEDIR}"
PKG_CONFIG_PATH=":${PKG_CONFIG_PATH}:${KDEDIR}/$(get_libdir)/pkgconfig"

# FIXME: fix cmake for that package and remove code below:
_common_configure_code() {
	local tmp_libdir=$(get_libdir)
	if has debug ${IUSE//+} && use debug; then
		echo -DCMAKE_BUILD_TYPE=Debug
	else
		echo -DCMAKE_BUILD_TYPE=Release
	fi
	echo -DCMAKE_C_COMPILER=$(type -P $(tc-getCC))
	echo -DCMAKE_CXX_COMPILER=$(type -P $(tc-getCXX))
	echo -DCMAKE_INSTALL_PREFIX=${PREFIX:-/usr}
	echo -DLIB_SUFFIX=${tmp_libdir/lib}
	echo -DLIB_INSTALL_DIR=${PREFIX:-/usr}/${tmp_libdir}
	[[ -n ${CMAKE_NO_COLOR} ]] && echo -DCMAKE_COLOR_MAKEFILE=OFF
}
#END OF FIXME

src_compile() {
	# This Plugin hard depends on libksane, deactivate it if use flag scanner is
	# not set.
	if ! use scanner; then
		sed -e '/acquireimages/ s:^:#DONOTCOMPILE :' -i "${S}"/CMakeLists.txt \
			|| die "Deactivating acquireimages plugin failed."
	fi

	# Fix linkage
	sed -e '/KDE4_KDEUI_LIBS/ c\\${KDE4_KIO_LIBS}'\
		-i "${S}"/common/libkipiplugins/CMakeLists.txt \
		|| die "Fixing kipi-plugins linkage failed."

	# FIXME: I know it's wrong and hackish, but package is carppy. I don't know cmake enough to fix it properly.

	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with opengl)
		$(cmake-utils_use_with scanner Sane)
		-DCMAKE_INSTALL_PREFIX=${PREFIX}
		-DKDE4_BUILD_TESTS=OFF
		-DKDE4_USE_ALWAYS_FULL_RPATH=ON
		-DCMAKE_INSTALL_PREFIX=${PREFIX}
		"

	# FIXME: Remove lines below when cmake for that package will be fixed!
	QTEST_COLORED=1
	QT_PLUGIN_PATH=${KDEDIR}/$(get_libdir)/kde4/plugins/
	# FIXME: Remove lines below when cmake for that package will be fixed!

	local cmakeargs="$(_common_configure_code) ${mycmakeargs} ${EXTRA_ECONF}"
	cmake ${cmakeargs} ./ || die "cmake failed"
	emake || die "emake failed"
}
