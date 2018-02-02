# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/ns/ns-2.31.ebuild,v 1.4 2008/09/03 07:36:41 opfer Exp $

EAPI=5

inherit eutils toolchain-funcs flag-o-matic autotools

DESCRIPTION="Network Simulator"
HOMEPAGE="http://www.isi.edu/nsnam/ns/"
SRC_URI="mirror://sourceforge/nsnam/${PN}-allinone-${PV}.tar.gz"

LICENSE="BSD as-is"
SLOT="0"
KEYWORDS="~ppc ~sparc x86 amd64"
IUSE="doc debug"

S=${WORKDIR}/${PN}-allinone-${PV}

RDEPEND="!!dev-tcltk/otcl
	!!dev-tcltk/tclcl
	!!net-analyzer/nam
	net-libs/libpcap
	debug? (	=dev-lang/perl-5*
			>=sci-visualization/xgraph-12.1
			>=dev-libs/dmalloc-4.8.2
			>=dev-tcltk/tcl-debug-2.0 )"
DEPEND="${RDEPEND}
    	doc? (	virtual/latex-base
				virtual/ghostscript
				dev-tex/latex2html )"
PDEPEND="sci-visualization/xgraph"

OPTDEST=/opt/ns2

src_prepare() {
	sed '/$(CC)/s!-g!$(CFLAGS)!g' "${S}/${PN}-${PV}/indep-utils/model-gen/Makefile" || die

        # dirty hack
	sed -i -e 's/@V_CCOPT@/@V_CCOPT@ -funsigned-char/g' "${S}/nam-1.15/Makefile.in" || die
    	
	epatch ${FILESDIR}/ns-2.35_mdart.patch
	epatch ${FILESDIR}/ns-2.35_linkstate.patch
	epatch ${FILESDIR}/ns-2.35_bitmap.patch
	epatch ${FILESDIR}/ns-2.35_common.patch
	
	epatch ${FILESDIR}/tcltk-conf.patch
	cd ${S}/${PN}-${PV}
	eautoreconf
}


src_compile() {
	local myconf
	local mytclver=""
	local i

	tc-export CC CXX

	# correctness is more important than speed
	replace-flags -Os -O2
	replace-flags -O3 -O2

	append-cxxflags -funsigned-char

	./install

	cd "${S}/${PN}-${PV}/indep-utils/dosdbell"
	emake DFLAGS="${CFLAGS}" || die
	cd "${S}/${PN}-${PV}/indep-utils/dosreduce"
	${CC} ${CFLAGS} dosreduce.c -o dosreduce
#	cd "${S}/${PN}-${PV}/indep-utils/propagation"
#	${CXX} ${CXXFLAGS} threshold.cc -o threshold
	cd "${S}/${PN}-${PV}/indep-utils/model-gen"
	emake CFLAGS="${CFLAGS}" || die

}

src_compile_() {
	local myconf
	local mytclver=""
	local i

	tc-export CC CXX

	# correctness is more important than speed
	replace-flags -Os -O2
	replace-flags -O3 -O2

	use debug \
		&& myconf="${myconf} --with-tcldebug=/usr/lib/tcldbg2.0" \
		|| myconf="${myconf} --with-tcldebug=no"
	myconf="${myconf} $(use_with debug dmalloc)"

	for i in 8.5 ; do
		einfo "Testing TCL ${i}"
		has_version "=dev-lang/tcl-${i}*" && mytclver=${i}
		[ "${#mytclver}" -gt 2 ] && break
	done
	einfo "Using TCL ${mytclver}"
	myconf="${myconf} --with-tcl-ver=${mytclver} --with-tk-ver=${mytclver}"

	econf \
		${myconf} \
		--mandir=/usr/share/man \
		--enable-stl \
		--enable-release || die "./configure failed"
	emake CCOPT="${CFLAGS}" || die

	cd "${S}/${PN}-${PV}/indep-utils/dosdbell"
	emake DFLAGS="${CFLAGS}" || die
	cd "${S}/${PN}-${PV}/indep-utils/dosreduce"
	${CC} ${CFLAGS} dosreduce.c -o dosreduce
#	cd "${S}/${PN}-${PV}/indep-utils/propagation"
#	${CXX} ${CXXFLAGS} threshold.cc -o threshold
	cd "${S}/${PN}-${PV}/indep-utils/model-gen"
	emake CFLAGS="${CFLAGS}" || die

	if useq doc; then
		einfo "Generating extra docs"
		cd "${S}/doc"
		yes '' | emake all
	fi
}

src_install() {
	cd ${S}/${PN}-${PV}
	dodir /usr/bin /usr/share/man/man1 /usr/share/doc/${PF} /usr/share/ns
	#make DESTDIR="${D}" MANDEST=/usr/share/man install \
	#	|| die "make install failed"

	dodir ${OPTDEST}/bin ${OPTDEST}/lib
	into ${OPTDEST}
	dobin nse

	dodoc BASE-VERSION COPYRIGHTS FILES HOWTO-CONTRIBUTE README VERSION
	dohtml CHANGES.html TODO.html

	cd "${S}"/${PN}-${PV}
	insinto /usr/share/ns
	doins -r tcl

	cd "${S}/${PN}-${PV}/indep-utils/dosdbell"
	dobin dosdbell dosdbellasim
	newdoc README README.dosdbell
	cd "${S}/${PN}-${PV}/indep-utils/dosreduce"
	dobin dosreduce
	newdoc README README.dosreduce
	cd "${S}/${PN}-${PV}/indep-utils/cmu-scen-gen"
	dobin cbrgen.tcl
	newdoc README README.cbrgen
#	cd "${S}/${PN}-${PV}/indep-utils/propagation"
#	dobin threshold
	cd "${S}/${PN}-${PV}/indep-utils/model-gen"
	dobin http_connect http_active

	if use doc; then
		cd "${S}/doc"
		docinto doc
		dodoc everything.dvi everything.ps.gz everything.html everything.pdf
		docinto model-gen
		cd "${S}/${PN}-${PV}/indep-utils/model-gen"
		dodoc *
	fi

	cd ${S}

	rm ${S}/bin/xgraph
#	rm ${S}/bin/tclsh8.5
#	rm ${S}/bin/wish8.5
#	rm ${S}/bin/cweave
#	rm ${S}/bin/ctangle

	into ${OPTDEST}
	dobin ${S}/bin/*
	cp -R ${S}/lib ${D}/${OPTDEST}
		
}

src_test() {
	einfo "Warning, these tests will take upwards of 45 minutes."
	einfo "Additionally, as shipped, a number of tests may fail."
	einfo "We log to 'validate.run', which you should compare against"
	einfo "the shipped 'validate.out' to evaluate success."
	einfo "At the time of assembling this ebuild, these test suites failed:"
	einfo "srm smac-multihop hier-routing algo-routing mcast vc"
	einfo "session mixmode webcache mcache plm wireless-tdma"
	./validate 2>&1 | tee "${S}/validate.run"
}
