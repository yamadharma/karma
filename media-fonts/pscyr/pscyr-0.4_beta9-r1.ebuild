# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit latex-package

IUSE=""

MY_PN=PSCyr
MY_P=${MY_PN}-${PV/_/-}
S=${WORKDIR}/PSCyr

DESCRIPTION="PSCyr font collection"
HOMEPAGE="ftp://scon155.phys.msu.su/pub/russian/psfonts"
SRC_URI="ftp://scon155.phys.msu.su/pub/russian/psfonts/0.4d-beta/${MY_P}-tex.tar.gz
ftp://scon155.phys.msu.su/pub/russian/psfonts/0.4d-beta/${MY_P}-type1.tar.gz"

DEPEND="virtual/tetex"

LICENSE="LPPL-1.2"
SLOT="0"
KEYWORDS="alpha amd64 hppa mips ppc sparc x86"

SUPPLIER="public"

src_install() {

   for each in dvips/pscyr tex/latex/pscyr fonts/tfm/public/pscyr \
	   fonts/vf/public/pscyr fonts/type1/public/pscyr fonts/afm/public/pscyr; do

	   cd ${S}
	   cd $each
	   latex-package_src_install
   done

   cd ${S}
   insinto ${TEXMF}/fonts/map/dvips/pscyr
   doins dvips/pscyr/pscyr.map || die "doins $i failed"

   for each in dvips/pscyr/*.enc; do
	   insinto ${TEXMF}/fonts/enc/dvips/pscyr
	   doins $each || die "doins $i failed"
   done

   insinto /etc/texmf/updmap.d
   doins ${FILESDIR}/90pscyr.cfg
   
   dodoc LICENSE doc/README.* doc/PROBLEMS ChangeLog
}

pkg_postinst() {

	latex-package_pkg_postinst
	updmap
}

pkg_postrm() {
	
	latex-package_pkg_setup
	
	einfo "Removing pk fonts..."
    
	rm -f $VARTEXFONTS/pk/modeless/public/pscyr/*
	rm -f $TEXMF/fonts/pk/modeless/public/pscyr/*
	rm -f $VARTEXMF/fonts/pk/modeless/public/pscyr/*

	latex-package_pkg_postrm
	updmap
}
