# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Math software for algebra, geometry, number theory, cryptography,
and numerical computation."
HOMEPAGE="http://www.sagemath.org"
SRC_URI="http://mirror.switch.ch/mirror/sagemath/src/${P}.tar"

inherit eutils flag-o-matic fortran

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=sys-devel/bison-2.3"

RDEPEND=">=virtual/jre-1.4"

pkg_setup() {
	FORTRAN="gfortran"
	fortran_pkg_setup
	einfo "Sage itself is released under the GPL-2 _or later_ license"
	einfo "However sage is distributed with packages having different licenses."
	einfo "This ebuild unfortunately does too, here is a list of licenses used:"
	einfo "BSD, LGPL, apache 2.0, PYTHON, MIT, public-domain, ZPL and as-is"
}

src_compile() {
	# This is so (at least) mpir will compile.
	ABI=32
	if [ $(uname -m) = 'x86_64' ]; then
		ABI=64
	fi

	emake || die "make failed"
	if ( grep "sage: An error occurred" ${S}/install.log ); then
		die "make failed"
	fi
}

src_install() {
	emake DESTDIR="${D}/opt" install
	sed -i "s/SAGE_ROOT=.*\/opt/SAGE_ROOT=\"\/opt/" "${D}/opt/bin/sage" "${D}/opt/sage/sage"
	exeinto /usr/bin
	dosym /opt/sage/sage /usr/bin/sage

	# Force sage to create files in new location.  This has to be done twice -
	# this time to create the files for gentoo to correctly record as part of
	# the sage install
	"${D}/opt/sage/sage" -c quit
}

pkg_postinst() {
	# make sure files are correctly setup in the new location by running sage as
	# root. This prevent nasty message to be presented to the user.
	/opt/sage/sage -c quit
}

