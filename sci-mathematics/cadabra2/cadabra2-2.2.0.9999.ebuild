# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
CMAKE_MIN_VERSION=3.1.0
PYTHON_COMPAT=( python{3_4,3_5,3_6} )

inherit cmake-utils texlive-common python-single-r1

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

CMAKE_IN_SOURCE_BUILD=y

pkg_setup() {

	if [[ -n `kpsewhich --var-value TEXMFSITE` ]]
	then
	    TEXMF="${EPREFIX}"`kpsewhich --var-value TEXMFSITE`
	else
	    TEXMF="${EPREFIX}"`kpsewhich --var-value TEXMFLOCAL`
	fi

}

src_prepare() {
	cmake-utils_src_prepare
	cd ${S}
	find . -name "CMakeLists.txt" -exec sed -i -e "s:COMPONENTS python-py34:COMPONENTS python:g" "{}" \;
	find . -name "CMakeLists.txt" -exec sed -i -e "s:COMPONENTS python-py35:COMPONENTS python:g" "{}" \;
	find . -name "CMakeLists.txt" -exec sed -i -e "s:COMPONENTS python-py36:COMPONENTS python:g" "{}" \;
	find . -name "CMakeLists.txt" -exec sed -i -e "s:COMPONENTS python3:COMPONENTS python:g" "{}" \;
	# multilib
	find . -name "CMakeLists.txt" -exec sed -i -e "s:DESTINATION lib:DESTINATION $(get_libdir):g" "{}" \;
	# Install prefix
	sed -i -e 's:ICON_PREFIX "/usr":ICON_PREFIX "${CMAKE_INSTALL_PREFIX}":g' \
    	    -e "s:^[[:space:]]*install(CODE:#install(CODE:g" \
	    ${S}/frontend/gtkmm/CMakeLists.txt
	sed -i -e "s:^[[:space:]]*install(CODE:#install(CODE:g" \
	    -e "s:^[[:space:]]*remove_file(:#remove_file(:g" \
	    ${S}/core/CMakeLists.txt
}

src_configure() {
	python_setup

	local mycmakeargs=(
	    -DPACKAGING_MODE=ON
	)

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

	insinto ${TEXMF}/tex/latex/cadabra2
	doins frontend/latex/tableaux.sty
	dodoc frontend/latex/young.html
	

#	rm -rf "${D}/usr/share/TeXmacs" || die

	# hack for texmf
#	mv ${D}/usr/share/texmf ${D}/usr/share/texmf-site
	
	# fix python path
	# sed -i -e '1 s:^.*$:\#\!/usr/bin/python3:' ${D}/usr/bin/cadabra2

#	CUR_PYTHON_DIR=`echo $PATH | cut -d: -f1`
#	sed -i -e "s:${CUR_PYTHON_DIR}/python:/usr/bin/python3:g" ${D}/usr/bin/cadabra2
	sed -i -e "s:${T}/python.*/bin/python:/usr/bin/python3:g" ${D}/usr/bin/cadabra2

}

pkg_postinst() {
	etexmf-update
	mktexlsr
	/usr/bin/gtk-update-icon-cache /usr/share/icons/hicolor
}

pkg_postrm() {
	etexmf-update
	mktexlsr
}

