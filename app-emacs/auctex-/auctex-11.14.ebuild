# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/app-emacs/auctex/auctex-10.0g.ebuild,v 1.1 2002/11/01 02:52:00 mkennedy Exp $

inherit elisp 

IUSE=""

DESCRIPTION="AUC TeX is an extensible package that supports writing and formatting TeX files"
HOMEPAGE="http://www.nongnu.org/auctex"
SRC_URI="http://savannah.nongnu.org/download/auctex/beta.pkg/${PV}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="virtual/emacs
	app-text/tetex"

S="${WORKDIR}/${P}"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -e 's,/usr/local/lib/texmf/tex/,/usr/share/texmf/tex/,g' tex.el >tex.el.new && \
		mv tex.el.new tex.el || die
}

src_compile() {
	make || die
}

src_install() {
	dodir ${SITELISP}/auctex
	make lispdir=${D}/${SITELISP} install install-contrib || die
	# this is insane...
	pushd ${D}/${SITELISP}
	sed -e "s,${D}/,,g" tex-site.el >tex-site.el.new && \
		mv tex-site.el.new tex-site.el || die
	popd

#	pushd doc
#	dodir /usr/share/info
#	make infodir=${D}/usr/share/info install || die
#	popd
# 	elisp-site-file-install ${FILESDIR}/50auctex-gentoo.el
  cd ${S}/doc
  doinfo auctex*
  
  cd ${S}/doc
  make all
  dodoc *.dvi
  
  cd ${S}
  dodoc ChangeLog CHANGES COPYING INSTALLATION PROBLEMS README NEWS INSTALL
}

pkg_postinst() 
{
 emacs -batch -l tex-site.el -f TeX-auto-generate-global
}

#pkg_postrm() {
#	elisp-site-regen
#}
