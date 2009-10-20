# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit flag-o-matic fortran xemacs-elisp-common

DESCRIPTION="High-level interactive language for numerical computations"
LICENSE="GPL-3"
HOMEPAGE="http://www.octave.org/"
SRC_URI="ftp://ftp.gnu.org/pub/gnu/${PN}/${P}.tar.bz2"
SLOT="0"
IUSE="64bit arpack emacs readline zlib doc hdf5 curl fftw xemacs sparse static-libs framework-opengl glpk qrupdate"
KEYWORDS="~alpha amd64 ~hppa ~ppc ~ppc64 ~sparc x86"

RDEPEND="virtual/lapack
	dev-libs/libpcre
	sys-libs/ncurses
	sci-visualization/gnuplot
	>=sci-mathematics/glpk-4.15
	media-libs/qhull
	fftw? ( >=sci-libs/fftw-3.1.2 )
	zlib? ( sys-libs/zlib )
	hdf5? ( sci-libs/hdf5 )
	curl? ( net-misc/curl )
	xemacs? ( app-editors/xemacs )
	sparse? ( sci-libs/umfpack
		sci-libs/colamd
		sci-libs/camd
		sci-libs/ccolamd
		sci-libs/cholmod
		sci-libs/cxsparse )
	framework-opengl? ( media-libs/glfw )
	media-libs/freetype:2
	media-libs/ftgl
	x11-libs/fltk:1.1[opengl]
	glpk? ( sci-mathematics/glpk )
	arpack? ( sci-libs/arpack )
	qrupdate? ( sci-libs/qrupdate )
	!sci-mathematics/octave-forge"

DEPEND="${RDEPEND}
	virtual/latex-base
	sys-apps/texinfo
	|| ( dev-texlive/texlive-genericrecommended
		app-text/ptex )
	dev-util/gperf
	dev-util/pkgconfig"

FORTRAN="gfortran ifc g77 f2c"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-3.2.2_parallel_make.patch \
		"${FILESDIR}"/${PN}-3.2.2_as_needed.patch
#	epatch "${FILESDIR}"/${PN}-3.2.2-dlmwrite.patch
}

src_configure() {
	econf \
		--localstatedir=/var/state/octave \
		--enable-shared \
		$(use_with arpack) \
		--with-blas="$(pkg-config --libs blas)" \
		--with-lapack="$(pkg-config --libs lapack)" \
		$(use_enable 64bit 64) \
		$(use_enable static-libs static) \
		--enable-shared \
		$(use_enable readline) \
		$(use_with zlib) \
		$(use_with hdf5) \
		$(use_with fftw) \
		$(use_with curl) \
		$(use_with framework-opengl) \
		$(use_with glpk) \
		$(use_with qrupdate) \
		$(use_with sparse amd) \
		$(use_with sparse umfpack) \
		$(use_with sparse colamd) \
		$(use_with sparse ccolamd) \
		$(use_with sparse cholmod) \
		$(use_with sparse cxsparse)
}

src_compile() {
	emake || die "emake failed"

	if use xemacs; then
		cd "${S}/emacs"
		xemacs-elisp-comp *.el
	fi
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"

	if use doc; then
		einfo "Installing documentation..."
		insinto /usr/share/doc/${PF}
		doins $(find doc -name \*.pdf)
	fi

	if use emacs || use xemacs; then
		cd emacs
		exeinto /usr/bin
		doexe octave-tags || die "Failed to install octave-tags"
		doman octave-tags.1 || die "Failed to install octave-tags.1"
		if use xemacs; then
			xemacs-elisp-install ${PN} *.el *.elc
		fi
		cd ..
	fi

	echo "LDPATH=/usr/$(get_libdir)/octave-${PV}" > 99octave
	doenvd 99octave || die
}
