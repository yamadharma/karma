# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit multilib

DESCRIPTION="A Flexible Indexing System"

MY_P=${PN}-kernel-${PV}

HOMEPAGE="http://www.xindy.org/"
SRC_URI="mirror://sourceforge/xindy/${MY_P}.tar.gz
mirror://sourceforge/xindy/xindy-2.3.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc x86"

IUSE="doc"
RDEPEND="virtual/latex-base
	>=dev-lisp/clisp-2.44.1-r1
	|| ( dev-texlive/texlive-langcyrillic app-text/ptex )"
DEPEND="${RDEPEND}
	sys-devel/flex"

src_compile() {
	cd ${WORKDIR}/xindy-2.3
	local clisp_dir
	clisp_dir=`clisp  --version | grep "Installation directory:" | sed 's/Installation directory: //'`
	econf \
		$(use_enable doc docs) \
		--enable-external-clisp --enable-clisp-dir=${clisp_dir}
	for i in modules make-rules doc
	do
		cd $i
		VARTEXFONTS="${T}/fonts" emake -j1 || die "Make failed"
		cd ../
	done

	cd ${WORKDIR}/${MY_P}
	for i in src tex2xindy user-commands
	do
		cd $i
		make clean
		make CLISP="clisp -q"
		cd ../
	done
}

src_install() {
	cd ${WORKDIR}/xindy-2.3
	for i in modules make-rules doc
	do
		cd $i
		emake DESTDIR="${D}" install || die "Install failed"
		cd ../
	done
	dodoc AUTHORS

	cd ${WORKDIR}/${MY_P}
	for i in src 
	do
		cd $i
		emake DESTDIR="${D}" INSTLIBDIR=${D}/usr/$(get_libdir)/${PN} install || die "Install failed"
		cd ../
	done
	cd user-commands
		dobin texindy xindy xindy.v2
		newman texindy.man texindy.1
		newman xindy.man xindy.1
		doman xindy.v2.1
		dodoc texindy.pdf xindy.pdf
	cd ../
	cd tex2xindy
		dobin tex2xindy
		doman tex2xindy.1
	cd ../
	dodoc NEWS README
}
