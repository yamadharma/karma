# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MAJOR="$(ver_cut 1)"
CADABRA="${PN}${MAJOR}"

PYTHON_COMPAT=( python3_{10..14} )

inherit xdg-utils python-single-r1 cmake

BUNDLED_MICROTEX_SUBMODULE_SHA="9dd1fb04884cbb1701806c6ad6f5405b4f01d934"

DESCRIPTION="Field-theory motivated approach to computer algebra"
HOMEPAGE="https://cadabra.science/
	https://github.com/kpeeters/cadabra2/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/kpeeters/${CADABRA}.git"
else
	SRC_URI="https://github.com/kpeeters/${CADABRA}/archive/${PV}.tar.gz -> ${P}.tar.gz
			https://github.com/kpeeters/MicroTeX/archive/${BUNDLED_MICROTEX_SUBMODULE_SHA}.tar.gz -> microtex-${BUNDLED_MICROTEX_SUBMODULE_SHA}.tar.gz"
	S="${WORKDIR}/${CADABRA}-${PV}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0/${MAJOR}"
IUSE="gui +jupyter test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="
	${PYTHON_DEPS}
	app-text/dvipng
	dev-cpp/glibmm:2
	dev-db/sqlite:3=
	dev-libs/boost:=
	dev-libs/gmp:=[cxx]
	dev-libs/jsoncpp:=
	dev-libs/libsigc++:2
	dev-texlive/texlive-basic
	$(python_gen_cond_dep '
		dev-python/gmpy2:2[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/sympy[${PYTHON_USEDEP}]
		jupyter? ( dev-python/jupyter[${PYTHON_USEDEP}] )
	')
	gui? (
		dev-cpp/gtkmm:3.0
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	$(python_gen_cond_dep 'dev-python/pybind11[${PYTHON_USEDEP}]')
"

PATCHES=( "${FILESDIR}/${CADABRA}-2.5.12-cmake.patch" )

DOCS=( CODE_OF_CONDUCT.md CONTRIBUTING.md JUPYTER.rst README.rst )

xdg_update() {
	if use gui ; then
		xdg_icon_cache_update
		xdg_desktop_database_update
		xdg_mimeinfo_database_update
	fi
}

src_prepare() {
	# Bundled submodules
	mkdir -p "${S}/submodules/microtex/"
	cp -rl "${WORKDIR}/MicroTeX-${BUNDLED_MICROTEX_SUBMODULE_SHA}"/* "${S}/submodules/microtex/"

	# Clean postinst script which calls libtool and icon-cache update
	echo '#!/bin/sh' > "${S}/config/postinst.in" || die

	# Fix "PYTHON_EXECUTABLE" in Jupyter kernel
	sed -i "s|@PYTHON_EXECUTABLE@|${EPYTHON}|"  \
		"${S}/jupyterkernel/kernelspec/kernel.json.in" || die

	cmake_src_prepare
}

src_configure() {
	local -a mycmakeargs=(
		-DENABLE_SYSTEM_JSONCPP=ON
		-DPACKAGING_MODE=ON
		-DUSE_PYTHON_3=ON
		-DBUILD_AS_CPP_LIBRARY=OFF
		-DENABLE_JUPYTER=OFF  # special Xeus Jupyter kernel (uses xtl)
		-DENABLE_MATHEMATICA=OFF
		-DINSTALL_TARGETS_ONLY=OFF
		-DBUILD_TESTS="$(usex test)"
		-DENABLE_FRONTEND="$(usex gui)"
		-DENABLE_PY_JUPYTER="$(usex jupyter)"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	python_optimize
}

pkg_postinst() {
	xdg_update
}

pkg_postrm() {
	xdg_update
}
