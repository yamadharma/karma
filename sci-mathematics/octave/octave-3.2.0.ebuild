# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit fortran xemacs-elisp-common

DESCRIPTION="High-level interactive language for numerical computations"
HOMEPAGE="http://www.octave.org/"
SRC_URI="ftp://ftp.gnu.org/pub/gnu/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ppc ~ppc64 ~sparc x86"
IUSE="emacs readline zlib doc hdf5 curl fftw fltk xemacs sparse"

RDEPEND="virtual/lapack
	dev-libs/libpcre
	sys-libs/ncurses
	sci-visualization/gnuplot
	>=sci-mathematics/glpk-4.15
	media-libs/qhull
	curl? ( net-misc/curl )
	fftw? ( >=sci-libs/fftw-3.1.2 )
	fltk? ( x11-libs/fltk[opengl] )
	hdf5? ( sci-libs/hdf5 )
	sparse? ( sci-libs/umfpack
		sci-libs/arpack
		sci-libs/camd
		sci-libs/ccolamd
		sci-libs/cholmod
		sci-libs/colamd
		sci-libs/cxsparse )
	xemacs? ( app-editors/xemacs )
	zlib? ( sys-libs/zlib )
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
	epatch "${FILESDIR}"/${PN}-3.0.0-pkg.patch
	epatch "${FILESDIR}"/${P}-test-fix.patch
	epatch "${FILESDIR}"/${P}-no_helvetica.patch
}

src_configure() {
	econf \
		--localstatedir=/var/state/octave \
		--enable-shared \
		--with-blas="$(pkg-config --libs blas)" \
		--with-lapack="$(pkg-config --libs lapack)" \
		$(use_with hdf5) \
		$(use_with curl) \
		$(use_with zlib) \
		$(use_with fltk) \
		$(use_with fftw) \
		$(use_with sparse arpack) \
		$(use_with sparse umfpack) \
		$(use_with sparse colamd) \
		$(use_with sparse ccolamd) \
		$(use_with sparse cholmod) \
		$(use_with sparse cxsparse) \
		$(use_enable readline)
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
