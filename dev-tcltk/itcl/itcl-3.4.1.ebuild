# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/itcl/itcl-3.4.1.ebuild,v 1.6 2015/03/28 21:43:14 ago Exp $

EAPI=5

inherit eutils multilib versionator

MY_P="${PN}${PV/_beta/b}"

DESCRIPTION="Object Oriented Enhancements for Tcl/Tk"
HOMEPAGE="http://incrtcl.sourceforge.net/"
SRC_URI="mirror://sourceforge/incrtcl/%5BIncr%20Tcl_Tk%5D-source/$(get_version_component_range 1-2)/${MY_P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~alpha amd64 ~ia64 ppc ~sparc x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

RDEPEND="dev-lang/tcl:8.5"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}${PV}"

src_configure() {
	econf \
		--with-tcl="${EPREFIX}"/usr/$(get_libdir)/tcl8.5 \
		--with-tclinclude="${EPREFIX}"/usr/$(get_libdir)
}


src_compile() {
	# adjust install_name on darwin
	if [[ ${CHOST} == *-darwin* ]]; then
		sed -i \
			-e 's:^\(SHLIB_LD\W.*\)$:\1 -install_name ${pkglibdir}/$@:' \
			"${S}"/Makefile || die 'sed failed'
	fi

	sed 's:-pipe::g' -i Makefile || die

	emake CFLAGS_DEFAULT="${CFLAGS}"
}

src_install() {
	default

	cat >> "${T}"/34${PN} <<- EOF
	LDPATH="${EPREFIX}/usr/$(get_libdir)/${PN}$(get_version_component_range 1-2)/"
	EOF
	doenvd "${T}"/34${PN}
}