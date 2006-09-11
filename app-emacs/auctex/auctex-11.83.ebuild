# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/auctex/auctex-11.83.ebuild,v 1.2 2006/06/25 12:18:45 dertobi123 Exp $

inherit elisp eutils latex-package autotools

DESCRIPTION="AUCTeX is an extensible package that supports writing and formatting TeX files"
HOMEPAGE="http://www.gnu.org/software/auctex"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE="preview-latex"

DEPEND="preview-latex? ( !dev-tex/preview-latex app-text/dvipng )"

src_unpack() {
	unpack ${A}
	cd ${S}

	# skip XEmacs detection. this is a workaround for emacs23
	epatch ${FILESDIR}/${PN}-11.82-configure.diff
}

src_compile() {
        local myconf=""
    
	myconf="${myconf} --disable-build-dir-test"
	myconf="${myconf} --with-lispdir=${SITELISP}"
	myconf="${myconf} --with-auto-dir=/var/lib/site-lisp/auctex"
	myconf="${myconf} `use_enable preview-latex preview`"

	econf \
	    ${myconf} || die "econf failed"
	
	emake || die
}

src_install() {
	make install DESTDIR=${D} || die
	dosed ${SITELISP}/tex-site.el || die
	elisp-site-file-install ${FILESDIR}/51auctex-gentoo.el
	if use preview-latex; then
	   elisp-site-file-install ${FILESDIR}/60auctex-gentoo.el
	fi
	dodoc ChangeLog CHANGES README RELEASE TODO FAQ INSTALL*

        if ( use doc )
    	    then
	    cd ${S}/doc
	    make tex-ref.pdf auctex.pdf
	    use preview-latex && make preview-latex.pdf
	    cp *.pdf ${D}/usr/share/doc/${PF}
	fi
	
	elisp-disable-elc

}

pkg_postinst () 
{
	elisp_pkg_postinst
	# rebuild TeX-inputfiles-database
	use preview-latex && latex-package_pkg_postinst
	
	elisp-site-regen
	
	emacs -batch -l tex-site.el -f TeX-auto-generate-global

	if [ -n "$ELISP_DISABLE_ELC" ]
	    then
	    cd /var/lib/site-lisp/auctex
	    for i in `find . -name '*.elc' -print`
	    do
		rm -f $i
	    done
	fi
}

pkg_postrm(){
	 use preview-latex && latex-package_pkg_postrm
	 elisp-site-regen
}

