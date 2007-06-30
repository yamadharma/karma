# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

FONT_SUPPLIER="urwcyr"
FONT_BUNDLE="base35"

IUSE="X gnustep tetex"

inherit font nfont latex-package


MY_PN=urw-fonts

MY_PV=${PV/_/}
MY_P=${MY_PN}-${MY_PV}

TEX_PV="01c"

DESCRIPTION="URW fonts cyrillized by Valek Filippov"
SRC_URI="ftp://ftp.gnome.ru/fonts/urw/release/${MY_P}.tar.bz2
	tetex? ( ftp://ftp.gnome.ru/fonts/urw/urw-TeX-${TEX_PV}.tbz2 )"
HOMEPAGE=""
KEYWORDS="x86 amd64"
LICENSE="GPL-2,LGPL,LPPL-1.2"
SLOT="0"

DEPEND="virtual/tetex
	dev-lang/perl"

S="${WORKDIR}"

FONT_FORMAT="type1"

FONT_SUFFIX="afm pfb"

FONT_S="${S}"

DOCS="ChangeLog README* TODO"

# For TeX fonts
SUPPLIER="public"
BUNDLE="urwcyr"

src_install ()
{
	font_src_install
	use gnustep && nfont_src_install

	if ( use tetex )     
	then
	    cd ${S}
	    perl urwren.pl
	    sed -ie "/system/s:,\":.\" :g" urwtfm.pl
	    perl urwtfm.pl
	    
	    for each in tex/latex/urwcyr fonts/afm/public/urwcyr fonts/tfm/public/urwcyr fonts/type1/public/urwcyr
	    do
		cd ${S}
		cd $each
		latex-package_src_install
	    done
	    
#	    cd ${S}
#	    latex-package_src_doinstall afm
#	    latex-package_src_doinstall pfb

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
	fi
}

pkg_postinst() {
	if ( use tetex )
	then
	    latex-package_pkg_postinst
	    updmap-sys
	fi
}

pkg_postrm() {
	if ( use tetex )
	then
	    latex-package_pkg_setup
	
	    einfo "Removing pk fonts..."
    
	    rm -f $VARTEXFONTS/pk/modeless/${SUPPLIER}/${BUNDLE}/*
	    rm -f $TEXMF/fonts/pk/modeless/${SUPPLIER}/${BUNDLE}/*
	    rm -f $VARTEXMF/fonts/pk/modeless/${SUPPLIER}/${BUNDLE}/*

	    latex-package_pkg_postrm
	    updmap-sys
	fi	
}




# Local Variables:
# mode: sh
# End:
