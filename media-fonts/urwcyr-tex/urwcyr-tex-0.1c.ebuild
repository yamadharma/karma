# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit latex-package

IUSE=""

S=${WORKDIR}

DESCRIPTION="TeX definitions for URW fonts cyrillized by Valek Filippov"
HOMEPAGE="ftp://ftp.gnome.ru/fonts/urw/"
SRC_URI="ftp://ftp.gnome.ru/fonts/urw/urw-TeX-${PV/./}.tbz2"

DEPEND="virtual/tetex"
RDEPEND="media-fonts/urwcyr-fonts"

LICENSE="LPPL-1.2"
SLOT="0"
KEYWORDS="x86 amd64"

SUPPLIER="public"
BUNDLE="urwcyr"

src_install() {
	for each in tex/latex/urwcyr
	do
	    cd ${S}
	    cd $each
	    latex-package_src_install
	done

	cd ${S}
	insinto ${TEXMF}/fonts/map/dvips/urwcyr
	doins ${S}/dvips/config/urwcyr.map || die "doins $i failed"

	insinto ${TEXMF}/fonts/map/dvipdfm/context
	doins ${S}/dvipdfm/config/urwpdf.map || die "doins $i failed"
	
	insinto /etc/texmf/updmap.d
	doins ${FILESDIR}/90urwcyr.cfg
   
	cd ${S}
	dodoc license problem readme
	cp ${S}/doc/urwcyr/* ${D}/usr/share/doc/${PF}
}

pkg_postinst() {

	latex-package_pkg_postinst
	updmap
}

pkg_postrm() {
	
	latex-package_pkg_setup
	
	einfo "Removing pk fonts..."
    
	rm -f $VARTEXFONTS/pk/modeless/${SUPPLIER}/${BUNDLE}/*
	rm -f $TEXMF/fonts/pk/modeless/${SUPPLIER}/${BUNDLE}/*
	rm -f $VARTEXMF/fonts/pk/modeless/${SUPPLIER}/${BUNDLE}/*

	latex-package_pkg_postrm
	updmap
}

