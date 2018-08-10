# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

RESTRICT="test"

inherit elisp-common eutils multilib pax-utils toolchain-funcs versionator

MY_PV=$(get_version_component_range 1-2 ${PV})

DESCRIPTION="High-performance programming language for technical computing"
HOMEPAGE="http://julialang.org/"
SRC_URI="
	x86? ( https://julialang-s3.julialang.org/bin/linux/x86/${MY_PV}/julia-${PV}-linux-i686.tar.gz )
	amd64? ( https://julialang-s3.julialang.org/bin/linux/x64/${MY_PV}/julia-${PV}-linux-x86_64.tar.gz )
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="mkl"

RESTRICT=strip

S=$WORKDIR/julia-${PV}
#GITHASH=d386e40c17
#S=${WORKDIR}/julia-${GITHASH}

RDEPEND="
	dev-lang/R:0=
	dev-libs/double-conversion:0=
	dev-libs/gmp:0=
	dev-libs/libgit2:0=
	dev-libs/mpfr:0=
	dev-libs/openspecfun
	sci-libs/arpack:0=
	sci-libs/camd:0=
	sci-libs/cholmod:0=
	sci-libs/fftw:3.0=[threads]
	sci-libs/openlibm:0=
	sci-libs/spqr:0=
	sci-libs/umfpack:0=
	sci-mathematics/glpk:0=
	sys-devel/llvm
	>=sys-libs/libunwind-1.1:7=
	sys-libs/readline:0=
	sys-libs/zlib:0=
	virtual/blas
	virtual/lapack
	mkl? ( sci-libs/mkl )"

DEPEND="${RDEPEND}
	dev-util/patchelf
	virtual/pkgconfig"


src_compile() {
	echo "Nothing to compile"
}


src_install() {
	JULIADIR=/opt/julia	

	cat > 99julia <<-EOF
		LDPATH=${EROOT%/}/${JULIADIR}/lib
	EOF
	doenvd 99julia

	dodir ${JULIADIR}
	mv ${S}/* ${ED}/${JULIADIR}
	
	dosym /${JULIADIR}/bin/julia /usr/bin/julia
	dosym /${JULIADIR}/bin/julia-debug /usr/bin/julia-debug

#	dodoc README.md

#	mv "${ED}"/usr/etc/julia "${ED}"/etc || die
#	rmdir "${ED}"/usr/etc || die
#	rmdir "${ED}"/usr/libexec || die
	
        dodir /usr/share/doc/${PN}-${PVR}
	mv "${ED}"/${JULIADIR}/share/doc/julia/* \
		"${ED}"/usr/share/doc/${PN}-${PVR} || die
	rmdir "${ED}"/${JULIADIR}/share/doc/julia || die
#	if [[ $(get_libdir) != lib ]]; then
#		mkdir -p "${ED}"/usr/$(get_libdir) || die
#		mv "${ED}"/usr/lib/julia "${ED}"/usr/$(get_libdir)/julia || die
#	fi
}

