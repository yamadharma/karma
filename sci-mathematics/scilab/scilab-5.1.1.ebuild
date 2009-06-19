# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/scilab/scilab-4.1.2-r1.ebuild,v 1.3 2008/11/15 18:41:11 dertobi123 Exp $

inherit eutils fortran toolchain-funcs multilib autotools java-pkg-2

DESCRIPTION="Scientific software package for numerical computations (Matlab lookalike)"
LICENSE="scilab"
SRC_URI="http://www.scilab.org/download/${PV}/${P}-src.tar.gz"
HOMEPAGE="http://www.scilab.org/"

SLOT="0"
IUSE="+tk -scicos +umfpack +gui +fftw -pvm +gui -doc +matio"
KEYWORDS="amd64 ppc x86"

RDEPEND="virtual/blas
	virtual/lapack
	virtual/cblas
	tk? (
		>=dev-lang/tk-8.4
		>=dev-lang/tcl-8.4
		)
	scicos? ( dev-lang/ocaml )
	umfpack? ( sci-libs/umfpack )
	doc? ( 
		dev-java/jeuclid-core
		dev-java/batik
		dev-java/fop
		dev-java/saxon
		app-text/docbook-xsl-stylesheets
		)
	gui? (
		dev-java/flexdock
		dev-java/gluegen
		dev-java/jogl
		dev-java/jgoodies-looks
		dev-java/skinlf
		dev-java/jrosetta
		dev-java/javahelp
		)
	fftw? ( sci-libs/fftw )
	matio? ( sci-libs/matio )
	pvm? ( sys-cluster/pvm )"

DEPEND="${RDEPEND}"


pkg_setup() {
	java-pkg-2_pkg_setup
	need_fortran gfortran g77
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-java-package-check.patch
	epatch "${FILESDIR}"/${P}-pvmfix.patch
	eautoreconf
	
	sed -i "s|jar_resolved=flexdock|jar_resolved=$(java-pkg_getjar flexdock flexdock.jar)|" configure
	sed -i "s|jar_resolved=looks|jar_resolved=$(java-pkg_getjar jgoodies-looks-2.0 looks.jar)|" configure
	sed -i "s|jar_resolved=skinlf|jar_resolved=$(java-pkg_getjar skinlf skinlf.jar)|" configure
	sed -i "s|jar_resolved=jogl|jar_resolved=$(java-pkg_getjar jogl jogl.jar)|" configure
	sed -i "s|jar_resolved=jhall|jar_resolved=$(java-pkg_getjar javahelp jhall.jar)|" configure
	sed -i "s|jar_resolved=gluegen-rt|jar_resolved=$(java-pkg_getjar gluegen gluegen-rt.jar)|" configure
	sed -i "s|jar_resolved=jrosetta-API|jar_resolved=$(java-pkg_getjar jrosetta jrosetta-API.jar)|" configure
	sed -i "s|jar_resolved=jrosetta-engine|jar_resolved=$(java-pkg_getjar jrosetta jrosetta-engine.jar)|" configure
	sed -i "s|jar_resolved=commons-logging|jar_resolved=$(java-pkg_getjar commons-logging commons-logging.jar)|" configure
	
	sed -i "/<\/librarypaths>/i\<path value=\"$(java-config -i gluegen)\"\/>" ${S}/etc/librarypath.xml
	sed -i "/<\/librarypaths>/i\<path value=\"$(java-config -i jogl)\"\/>" ${S}/etc/librarypath.xml
}

src_compile() {
	local myopts
	myopts="${myopts} --with-jdk=`java-config -O`"
	if use doc ; then
		myopts="${myopts} -with-docbook=/usr/share/sgml/docbook/xsl-stylesheets/"
	fi
	econf \
		$(use_with scicos) \
		$(use_with tk) \
		$(use_with fftw) \
		$(use_with gui)\
		$(use_with gui javasci)\
		$(use_with pvm) \
		$(use_with matio) \
		$(use_with scicos) \
		$(use_with umfpack) \
		$(use_enable doc build-help) \
		${myopts} || die "econf failed"

	emake || die "emake failed"
	make macros || die "make macros failed"
}

src_install() {
	DESTDIR="${D}" make install || die "installation failed"
	
	# install docs
	dodoc ACKNOWLEDGEMENTS CHANGES README_Unix RELEASE_NOTES \
		Readme_Visual.txt || die "failed to install docs"

}
