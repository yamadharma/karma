# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils flag-o-matic python-single-r1

RELEASE="1.2.0"
COMMIT="258105b4d8957e0245a341cdf1dc12c72234c833"

DESCRIPTION="Advanced molecular editor that uses Qt4 and OpenGL"
HOMEPAGE="http://avogadro.openmolecules.net/"
SRC_URI="https://github.com/cryos/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+glsl cpu_flags_x86_sse2 test"

RDEPEND="
	glsl? ( >=media-libs/glew-1.5.0 )
	>=dev-libs/boost-1.35.0-r5[${PYTHON_USEDEP}]
	>=dev-qt/qtgui-4.8.5:4
	>=dev-qt/qtopengl-4.8.5:4
	>=sci-chemistry/openbabel-2.3.0
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/sip[${PYTHON_USEDEP}]
	x11-libs/gl2ps
	"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-cpp/eigen"

RESTRICT="test"

PATCHES=(
	"${FILESDIR}/${PN}-${RELEASE}-boost-join-moc.patch"
	"${FILESDIR}/${PN}-${RELEASE}-mkspecs-dir.patch"
	"${FILESDIR}/${PN}-${RELEASE}-no-strip.patch"
	"${FILESDIR}/${PN}-${RELEASE}-openbabel.patch"
	"${FILESDIR}/${PN}-${RELEASE}-pkgconfig_eigen.patch"
	"${FILESDIR}/${PN}-${RELEASE}-numpy.patch"
)

S="${WORKDIR}/${PN}-${COMMIT}"

src_prepare() {
	sed \
		-e 's:_BSD_SOURCE:_DEFAULT_SOURCE:g' \
		-i CMakeLists.txt || die
	append-cppflags -DEIGEN_NO_EIGEN2_DEPRECATED_WARNING
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_THREADEDGL=OFF
		-DENABLE_RPATH=OFF
		-DENABLE_UPDATE_CHECKER=OFF
		-DQT_MKSPECS_DIR="${EPREFIX}/usr/share/qt4/mkspecs"
		-DENABLE_GLSL="$(usex glsl)"
		-DENABLE_TESTS="$(usex test)"
		-DWITH_SSE2="$(usex cpu_flags_x86_sse2)"
	)

	cmake-utils_src_configure
}
