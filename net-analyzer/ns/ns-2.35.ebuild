# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/ns/ns-2.31.ebuild,v 1.4 2008/09/03 07:36:41 opfer Exp $

EAPI="3"

inherit eutils toolchain-funcs flag-o-matic multilib

MY_P=${PN}-allinone-${PV/_rc/-RC}

DESCRIPTION="Network Simulator"
HOMEPAGE="http://www.isi.edu/nsnam/ns/"
SRC_URI="mirror://sourceforge/nsnam/${MY_P}.tar.gz
	http://www.isi.edu/nsnam/dist/release/${MY_P}.tar.gz"

LICENSE="BSD as-is"
SLOT="0"
KEYWORDS="~ppc ~sparc x86 amd64"
IUSE="doc debug"

RDEPEND="!net-analyzer/nam
	!sci-visualization/xgraph
	net-libs/libpcap
	debug? (	=dev-lang/perl-5*
				>=dev-libs/dmalloc-4.8.2
				>=dev-tcltk/tcl-debug-2.0 )"
DEPEND="${RDEPEND}
		doc? (	virtual/latex-base
				virtual/ghostscript
				dev-tex/latex2html )"

S=${WORKDIR}/${MY_P}
S_NS=${S}/${PN}-${PV%%_rc*}

TCLVER=8.5.8
TKVER=8.5.8
NAMVER=1.15
XGRAPHVER=12.2
DEI80211MRVER=1.1.4

src_prepare() {
#	sed '/$(CC)/s!-g!$(CFLAGS)!g' "${S}/indep-utils/model-gen/Makefile"
#	has_version '>=sys-devel/gcc-4.5' && epatch ${FILESDIR}/ns-2.34-gcc-4.5.patch

	sed -i -e "s/^INSTALL_TARGETS = \(.*\)install-doc\(.*\)/INSTALL_TARGETS = \1 \2/g" ${S}/tk${TKVER}/unix/Makefile.in
	sed -i -e "s/^INSTALL_TARGETS = \(.*\)install-demos\(.*\)/INSTALL_TARGETS = \1 \2/g" ${S}/tk${TKVER}/unix/Makefile.in
	sed -i -e "s/^INSTALL_TARGETS = \(.*\)install-doc\(.*\)/INSTALL_TARGETS = \1 \2/g" ${S}/tk${TCLVER}/unix/Makefile.in
}


src_compile() {
	local myconf
	local mytclver=""
	local i

	tc-export CC CXX

	# correctness is more important than speed
	replace-flags -Os -O2
	replace-flags -O3 -O2

	use debug \
		&& myconf="${myconf} --with-tcldebug=/usr/$(get_libdir)/tcldbg2.0" \
		|| myconf="${myconf} --with-tcldebug=no"
	myconf="${myconf} $(use_with debug dmalloc)"

	./install

	cd "${S_NS}/indep-utils/dosdbell"
	emake DFLAGS="${CFLAGS}" || die
	cd "${S_NS}/indep-utils/dosreduce"
	${CC} ${CFLAGS} dosreduce.c -o dosreduce
	cd "${S_NS}/indep-utils/propagation"
	${CXX} ${CXXFLAGS} threshold.cc -o threshold
	cd "${S_NS}/indep-utils/model-gen"
	emake CFLAGS="${CFLAGS}" || die

	if useq doc; then
		einfo "Generating extra docs"
		cd "${S_NS}/doc"
		yes '' | emake all
	fi
}

src_install() {
	cd ${S_NS}
	dodir /usr/bin /usr/share/man/man1 /usr/share/doc/${PF} /usr/share/ns
	make DESTDIR="${D}" MANDEST=/usr/share/man BINDEST=/usr/bin install \
		|| die "make install failed"
	dobin nse

	dodoc BASE-VERSION COPYRIGHTS FILES HOWTO-CONTRIBUTE README VERSION
	dohtml CHANGES.html TODO.html

	cd "${S_NS}"
	insinto /usr/share/ns
	doins -r tcl

	cd "${S_NS}/indep-utils/dosdbell"
	dobin dosdbell dosdbellasim
	newdoc README README.dosdbell
	cd "${S_NS}/indep-utils/dosreduce"
	dobin dosreduce
	newdoc README README.dosreduce
	cd "${S_NS}/indep-utils/cmu-scen-gen"
	dobin cbrgen.tcl
	newdoc README README.cbrgen
	cd "${S_NS}/indep-utils/propagation"
	dobin threshold
	cd "${S_NS}/indep-utils/model-gen"
	dobin http_connect http_active

	cd ${S}/nam-${NAMVER}
	make DESTDIR="${D}" MANDEST=/usr/share/man BINDEST=/usr/bin install || die "make install failed"

	cd ${S}/xgraph-${XGRAPHVER}
	make DESTDIR="${D}" MANDEST=/usr/share/man BINDEST=/usr/bin prefix=/usr install || die "make install failed"

#	cd ${S}/dei80211mr-${DEI80211MRVER}
#	make DESTDIR="${D}" MANDEST=/usr/share/man  install || die "make install failed"
	dodir /usr/$(get_libdir)
	dodir /usr/share
	mv ${S}/lib/libdei* ${D}/usr/$(get_libdir)
	mv ${S}/share/aclocal ${D}/usr/share

#	cd ${S}/sgb
#	make SGBDIR=${D}/usr/$(get_libdir)/sgb CWEBINPUTS=${D}/usr/$(get_libdir)/cweb LIBDIR=${D}/usr/$(get_libdir) || die "make install failed"

	dobin ${S}/gt-itm/bin/*
	dodoc ${S}/gt-itm/docs/*

	if use doc; then
		cd "${S_NS}/doc"
		docinto doc
		dodoc everything.dvi everything.ps.gz everything.html everything.pdf
		docinto model-gen
		cd "${S_NS}/indep-utils/model-gen"
		dodoc *
	fi
}

src_test() {
	einfo "Warning, these tests will take upwards of 45 minutes."
	einfo "Additionally, as shipped, a number of tests may fail."
	einfo "We log to 'validate.run', which you should compare against"
	einfo "the shipped 'validate.out' to evaluate success."
	einfo "At the time of assembling this ebuild, these test suites failed:"
	einfo "srm smac-multihop hier-routing algo-routing mcast vc"
	einfo "session mixmode webcache mcache plm wireless-tdma"
	cd "${S_NS}"
	./validate 2>&1 | tee "${S}/validate.run"
}
