# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/app-emacs/auctex/auctex-10.0g.ebuild,v 1.1 2002/11/01 02:52:00 mkennedy Exp $

IUSE="doc"

inherit elisp


DESCRIPTION="AUC TeX is an extensible package that supports writing and formatting TeX files"
HOMEPAGE="http://www.gnu.org/software/auctex"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND="virtual/emacs
	virtual/tetex"

SITEFILE=50auctex-gentoo.el


src_compile () 
{
    local myconf=""
    local tex_input_dirs="/usr/share/texmf/"
    
    if [ -d /usr/local/share/texmf/ ]
	then
	tex_input_dirs="${tex_input_dirs};/usr/local/share/texmf/;/usr/share/texmf/bibtex/bst/;/usr/local/share/texmf/bibtex/bst/"
    fi
    
    myconf="${myconf} --with-tex-input-dirs=${tex_input_dirs}"
    myconf="${myconf} --with-lispdir=${SITELISP}"
    myconf="${myconf} --with-auto-dir=/var/lib/site-lisp/auctex"
    
    econf \
	${myconf} || die "econf failed"
	
    make || die
}

src_install () 
{
    make install-lisp DESTDIR=${D} \
	|| die

    cd ${S}/doc
    make auctex
    mv auctex auctex.info
    doinfo auctex.info
    
    if ( use doc )
	then
	cd ${S}/doc
	make all
	dodoc *.dvi
    fi
    
    cd ${S}
    dodoc ChangeLog COPYING README* INSTALL* FAQ TODO
    
    # fix info documentation
#    find ${D}/usr/share/info -type f -exec mv {}.gz {}.info.gz \;
    
    use ecf || elisp-site-file-install ${FILESDIR}/${SITEFILE}
}

pkg_postinst () 
{
    elisp_pkg_postinst
    emacs -batch -l tex-site.el -f TeX-auto-generate-global
}


# Local Variables:
# mode: sh
# End:
