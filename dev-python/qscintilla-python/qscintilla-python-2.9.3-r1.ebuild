# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/qscintilla-python/qscintilla-python-2.9.ebuild,v 1.1 2015/04/30 13:50:25 pesa Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit python-r1 qmake-utils

MY_P=QScintilla_gpl-${PV}

DESCRIPTION="Python bindings for Qscintilla"
HOMEPAGE="http://www.riverbankcomputing.com/software/qscintilla/intro"
SRC_URI="mirror://sourceforge/pyqt/${MY_P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug +qt5"

DEPEND="
	${PYTHON_DEPS}
	>=dev-python/sip-4.16:=[${PYTHON_USEDEP}]
	>=dev-python/PyQt4-4.11.3[X,${PYTHON_USEDEP}]
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	~x11-libs/qscintilla-${PV}:=[qt5(-)]
	qt5? ( 
		dev-qt/qtcore:5 
		dev-qt/qtgui:5 
		dev-qt/qtwidgets:5 
		dev-qt/qtprintsupport:5 
		dev-python/PyQt5[gui,widgets,printsupport,${PYTHON_USEDEP}]
		)
"
RDEPEND="${DEPEND}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S=${WORKDIR}/${MY_P}/Python

src_prepare() {
#	if use qt5; then
		pushd "${WORKDIR}/${MY_P}" >/dev/null
#		epatch "${FILESDIR}/qt5_python_libname.patch"
		epatch "${FILESDIR}/qt5_includes.patch"
#		epatch "${FILESDIR}/qsci_link.patch"
		popd >/dev/null
#	fi
	python_copy_sources
}

src_configure() {
#	configuration_qt4() {
#		local myconf=(
#			"${PYTHON}" ../configure.py
#			--qmake="$(qt4_get_bindir)"/qmake
#			--destdir="$(python_get_sitedir)"/PyQt4
#			--sip-incdir="$(python_get_includedir)"
#			--pyqt=PyQt4
#			$(use debug && echo --debug)
#		)
#		mkdir buildqt4
#		cp -r sip buildqt4
#		pushd buildqt4 >/dev/null
#		echo "${myconf[@]}"
#		"${myconf[@]}" || die
#
#		# Run eqmake4 to respect toolchain, build flags, and prevent stripping
#		eqmake4
#		popd >/dev/null
#	}
	configuration_qt5() {
		local myconf=(
			"${PYTHON}" ../configure.py
			--qmake="$(qt5_get_bindir)"/qmake
			--destdir="$(python_get_sitedir)"/PyQt5
			--sip-incdir="$(python_get_includedir)"
			--pyqt=PyQt5
			$(use debug && echo --debug)
		)
		mkdir buildqt5
		cp -r sip buildqt5
		pushd buildqt5 >/dev/null
		echo "${myconf[@]}"
		"${myconf[@]}" || die

		eqmake5
		popd >/dev/null
	}

	#python_foreach_impl run_in_build_dir configuration_qt4
	
	#if use qt5; then
		python_foreach_impl run_in_build_dir configuration_qt5
	#fi
}

src_compile() {
#	compile_qt4() {
#		pushd buildqt4 >/dev/null
#		emake || die "emake failed (qt4)"
#		popd >/dev/null
#	}
	compile_qt5() {
		pushd buildqt5 >/dev/null
		emake || die "emake failed (qt5)"
		popd >/dev/null
	}
	#python_foreach_impl run_in_build_dir compile_qt4

	#if use qt5; then
		python_foreach_impl run_in_build_dir compile_qt5
	#fi
}

src_install() {
#	installation_qt4() {
#		pushd buildqt4 >/dev/null
#		emake INSTALL_ROOT="${D}" install
#		python_optimize
#		popd >/dev/null
#	}
	installation_qt5() {
		pushd buildqt5 >/dev/null
		emake INSTALL_ROOT="${D}" install
		python_optimize
		popd >/dev/null
	}
	#python_foreach_impl run_in_build_dir installation_qt4

	#if use qt5; then
		python_foreach_impl run_in_build_dir installation_qt5
	#fi
}
