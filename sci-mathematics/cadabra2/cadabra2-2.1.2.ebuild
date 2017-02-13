# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit cmake-utils texlive-common

DESCRIPTION="Field-theory motivated computer algebra system"
HOMEPAGE="http://cadabra.science/"

if [[ ${PV} = *.9999* ]]; then
        inherit git-r3
        EGIT_REPO_URI="https://github.com/kpeeters/cadabra2.git"
        KEYWORDS="~amd64 ~x86"
else
	inherit git-r3
        EGIT_REPO_URI="https://github.com/kpeeters/cadabra2.git"
        EGIT_COMMIT="${PV}"
        KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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
	enable_cmake-utils_src_prepare
	cd ${S}
#	find . -name "CMakeLists.txt" -exec sed -i -e "s:COMPONENTS python-py34:COMPONENTS python-3.4:g" "{}" \;
	find . -name "CMakeLists.txt" -exec sed -i -e "s:COMPONENTS python-py34:COMPONENTS python:g" "{}" \;
	find . -name "CMakeLists.txt" -exec sed -i -e "s:COMPONENTS python3:COMPONENTS python:g" "{}" \;
}

src_configure() {
#	PYTHON_CURRENT=`eselect python show`
#	echo $PYTHON_CURRENT !!!!!
#	if [[ $PYTHON_CURRENT == "python2.7" ]]
#	then
#	    eselect python set python3.4
#	fi
#	export GIT_DIR=${S}/.git/

#        local mycmakeargs=(
#                -DUSE_PYTHON_3=ON
#        )
        cmake-utils_src_configure

	eselect python set $PYTHON_CURRENT
}

src_install() {
	enable_cmake-utils_src_install
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

