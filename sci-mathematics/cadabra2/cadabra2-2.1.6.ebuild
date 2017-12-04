# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python{3_4,3_5,3_6} )

inherit cmake-utils texlive-common python-r1

DESCRIPTION="Field-theory motivated computer algebra system"
HOMEPAGE="http://cadabra.science/"

if [[ ${PV} = *.9999* ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://github.com/kpeeters/cadabra2.git"
        KEYWORDS="~amd64 ~x86"
else
	SRC_URI="https://github.com/kpeeters/cadabra2/archive/${PV}.tar.gz -> ${P}.tar.gz"
        KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="doc examples"

CDEPEND="x11-libs/gtk+:3
	dev-cpp/gtkmm:3.0
	dev-libs/boost
	dev-libs/jsoncpp
	dev-libs/mathjax
	dev-python/sympy
	"

DEPEND="${CDEPEND}
	doc? (
		app-doc/doxygen
		dev-texlive/texlive-latexextra
		|| ( app-text/texlive-core dev-tex/pdftex ) )"

RDEPEND="${CDEPEND}
	virtual/latex-base
	dev-texlive/texlive-latexrecommended"

PATCHES=(
	"${FILESDIR}/remove-rm.patch"
	"${FILESDIR}/remove-touch.patch"
)

CMAKE_IN_SOURCE_BUILD=y

src_prepare() {
	cmake-utils_src_prepare
	cd ${S}
	find . -name "CMakeLists.txt" -exec sed -i -e "s:COMPONENTS python-py34:COMPONENTS python:g" "{}" \;
	find . -name "CMakeLists.txt" -exec sed -i -e "s:COMPONENTS python-py35:COMPONENTS python:g" "{}" \;
	find . -name "CMakeLists.txt" -exec sed -i -e "s:COMPONENTS python-py36:COMPONENTS python:g" "{}" \;
	find . -name "CMakeLists.txt" -exec sed -i -e "s:COMPONENTS python3:COMPONENTS python:g" "{}" \;
	# multilib
	find . -name "CMakeLists.txt" -exec sed -i -e "s:DESTINATION lib:DESTINATION $(get_libdir):g" "{}" \;
}

src_configure() {
	python_setup 'python3*'

        cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	# cadabra strip binaries unless you are on OS X.
	# So faking it to avoid outright stripping.
#	emake DESTDIR="${D}" DEVDESTDIR="${D}" MACTEST=1 install
#	einstall

#	dodoc AUTHORS ChangeLog INSTALL

#	if use doc;	
#	then
#		cd "${S}/doc/doxygen"
#		dohtml html/*
#		dodoc latex/*.pdf
#	fi

	if use examples; then
		dodoc -r "${S}/examples/"
	fi

#	rm -rf "${D}/usr/share/TeXmacs" || die

	# hack for texmf
#	mv ${D}/usr/share/texmf ${D}/usr/share/texmf-site
}

pkg_postinst() {
	etexmf-update
}

pkg_postrm() {
	etexmf-update
}

