# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/app-emacs/auctex/auctex-10.0g.ebuild,v 1.1 2002/11/01 02:52:00 mkennedy Exp $

inherit elisp patch extrafiles

IUSE="${IUSE}"

DESCRIPTION="AUC TeX is an extensible package that supports writing and formatting TeX files"
HOMEPAGE="http://www.gnu.org/software/auctex"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND=">=sys-apps/sed-4
	virtual/emacs
	app-text/tetex"

S="${WORKDIR}/${P}"

SITEFILE=50auctex-gentoo.el

pkg_setup () 
{

    if ! grep ' Xaw3d' /var/db/pkg/app-editors/emacs*/USE >/dev/null 2>&1
	then
	ewarn
	ewarn "Emacs needs to be compiled with Xaw3d support."
	ewarn "Please emerge emacs with USE=\"Xaw3d\"."
	ewarn
	die "Emacs Xaw3d support must be enabled."
    fi
}

src_unpack () 
{
    patch_src_unpack
    cd ${S}
    . ./autogen.sh

    sed -i -e 's:/usr/local/lib/texmf/tex/:/usr/share/texmf/tex/:g' tex.el || die
    
}

src_compile () 
{
    econf
    make || die
}

src_install () 
{
    dodir ${SITELISP}/auctex
    make lispdir=${D}/${SITELISP}/auctex install install-contrib || die
    dosed -e "s:${D}/::g" ${SITELISP}/tex-site.el || die

    cd ${S}/doc
    doinfo auctex*
  
    cd ${S}/doc
    make all
    dodoc *.dvi
  
    cd ${S}
    dodoc ChangeLog CHANGES COPYING INSTALLATION PROBLEMS README* NEWS INSTALL
    
    extrafiles_install
    
#     cd ${D}/${SITELISP}/auctex
#     gzip *.el
#     cd ${D}/${SITELISP}/auctex/style
#     gzip *.el
}

pkg_postinst () 
{
    emacs -batch -l tex-site.el -f TeX-auto-generate-global
}


# Local Variables:
# mode: sh
# End:
