# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI=3
#CMAKE_IN_SOURCE_BUILD=1
#inherit eutils virtualx cmake-utils multilib
inherit cmake-utils multilib flag-o-matic

MY_P="${PN}-src-${PV}"
DESCRIPTION="MIT Object extension to Tcl"
HOMEPAGE="http://otcl-tclcl.sourceforge.net/otcl/"
SRC_URI="mirror://sourceforge/otcl-tclcl/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

DEPEND="dev-lang/tcl:8.5
                dev-lang/tk:8.5"

# the package is not safe :-(
MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
#	epatch "${FILESDIR}"/${PN}-1.14-configure-cleanup.patch
#        eautoreconf
	cp ${FILESDIR}/CMakeLists.txt .
	cp ${FILESDIR}/otcl.pc.cmake .
}

src_configure() {
	append-flags -DHAVE_UNISTD_H

	local mycmakeargs=(
		-DLIB_INSTALL_DIR=/usr/$(get_libdir) 
		-DINCLUDE_INSTALL_DIR=/usr/include
	)
	cmake-utils_src_configure
#	cmake ${S}
}

src_compile-() {
	#CFLAGS="${CFLAGS} -DHAVE_UNISTD_H" 
	#emake
	cmake-utils_src_compile
}

src_install-() {
	einstall
}

src_compile_() {
        local tclv tkv myconf
        tclv=$(grep TCL_VER /usr/include/tcl.h | sed 's/^.*"\(.*\)".*/\1/')
        tkv=$(grep TK_VER /usr/include/tk.h | sed 's/^.*"\(.*\)".*/\1/')
        myconf="--with-tcl-ver=${tclv} --with-tk-ver=${tkv} --with-tcl=/usr/$(get_libdir)"
        CFLAGS="${CFLAGS} -I/usr/$(get_libdir)/tcl${tkv}/include/generic -I/usr/$(get_libdir)/tcl8.5/include/unix -DHAVE_UNISTD_H"

        echo myconf $myconf
        econf ${myconf} || die "econf failed"
        emake all || die "emake all failed"
        emake libotcl.so || die  "emake libotcl.so failed"
}

src_install_() {
        dobin otclsh owish
        dolib libotcl.so
        dolib.a libotcl.a
        insinto /usr/include
        doins otcl.h


        # docs
        dodoc VERSION
        dohtml README.html CHANGES.html
        docinto doc
        dohtml doc/*.html
}

src_test() {
        Xmake
test
}
