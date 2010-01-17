# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/scilab/scilab-4.1.2-r1.ebuild,v 1.3 2008/11/15 18:41:11 dertobi123 Exp $

EAPI=2
inherit autotools eutils flag-o-matic fortran java-pkg-2

DESCRIPTION="Scientific software package for numerical computations (Matlab lookalike)"
LICENSE="CeCILL-2"
SRC_URI="http://www.scilab.org/download/${PV}/${P}-src.tar.gz"
HOMEPAGE="http://www.scilab.org/"

SLOT="0"
IUSE="+tk -scicos +umfpack +gui +fftw -pvm +gui +doc +matio -hdf5"
# KEYWORDS="~amd64 ~x86"

RDEPEND="virtual/blas
		virtual/lapack
		virtual/cblas
		tk? (
			>=dev-lang/tk-8.4
			>=dev-lang/tcl-8.4
		)
		scicos? ( dev-lang/ocaml )
		umfpack? ( sci-libs/umfpack )
		gui? (
			>=virtual/jdk-1.5
			dev-java/commons-logging
			dev-java/flexdock
			dev-java/gluegen
			dev-java/jeuclid-core
			dev-java/jlatexmath
			dev-java/jgraphx
			dev-java/jogl
			dev-java/jgoodies-looks
			dev-java/skinlf
			dev-java/jrosetta
			dev-java/javahelp
		)
		fftw? ( sci-libs/fftw )
		matio? ( sci-libs/matio )
		pvm? ( sys-cluster/pvm )
		hdf5? ( dev-java/hdf-java )"

DEPEND="doc? (
			~dev-java/batik-1.7
			dev-java/fop
			~dev-java/saxon-6.5.5
			app-text/docbook-xsl-stylesheets
			)
		${RDEPEND}"

S="${WORKDIR}/${PN}-${PV}"
#JAVA_PKG_STRICT=1

pkg_setup() {
	need_fortran gfortran g77
	append-ldflags -Wl,--no-as-needed
}

src_prepare() {
	cd ${S}
	#add the correct java directories to the config file
	sed -i "/^.DEFAULT_JAR_DIR/{s|=.*|=\"$(echo $(ls -d /usr/share/*/lib))\"|}" m4/java.m4 || die

	eautoreconf

	sed -i "s|-L\$SCI_SRCDIR/bin/|-L\$SCI_SRCDIR/bin/ \
		-L$(java-config -i gluegen) \
		-L$(java-config -i hdf-java) \
		-L$(java-config -i jogl)|" configure || die

	sed -i "/<\/librarypaths>/i\<path value=\"$(java-config -i gluegen)\"\/>" "${S}/etc/librarypath.xml" || die
	sed -i "/<\/librarypaths>/i\<path value=\"$(java-config -i jogl)\"\/>" "${S}/etc/librarypath.xml" || die
	sed -i "/<\/librarypaths>/i\<path value=\"$(java-config -i hdf-java)\"\/>" "${S}/etc/librarypath.xml" || die
	java-pkg-2_src_prepare
}

src_configure() {
	local myopts
	if use doc ; then
		myopts="${myopts} -with-docbook=/usr/share/sgml/docbook/xsl-stylesheets/"
	fi
	export JAVA_HOME=$(java-config -O)

	econf --disable-rpath\
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
		$(use_with hdf5) \
		${myopts} || die "econf failed"
}

src_compile() {
	emake|| die "emake failed"

	if use doc; then
		emake doc
	fi

}

src_install() {
	DESTDIR="${D}" make install || die "installation failed"

	# install docs
	dodoc ACKNOWLEDGEMENTS CHANGES README_Unix RELEASE_NOTES \
		Readme_Visual.txt || die "failed to install docs"

	#install icon
	newicon icons/scilab.xpm scilab.xpm

	make_desktop_entry ${PN} "Scilab" ${PN} "Education;Math"
}

pkg_postinst() {
	einfo "To tell Scilab about your printers, set the environment"
	einfo "variable PRINTERS in the form:"
	einfo
	einfo "PRINTERS=\"firstPrinter:secondPrinter:anotherPrinter\""
}
