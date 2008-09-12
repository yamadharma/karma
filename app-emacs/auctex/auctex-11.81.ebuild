# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit elisp eutils

DESCRIPTION="AUC TeX is an extensible package that supports writing and formatting TeX files"
HOMEPAGE="http://www.gnu.org/software/auctex"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc-macos ~ppc64 ~sparc x86"
IUSE="preview-latex doc"

DEPEND="virtual/emacs
	virtual/latex-base
	preview-latex? ( !dev-tex/preview-latex )"

SITEFILE=50auctex-gentoo.el

src_unpack () 
{
	unpack ${A}
	cd ${S}

	# skip XEmacs detection. this is a workaround for emacs23
	epatch ${FILESDIR}/${P}-configure.diff
}


src_compile () 
{
        local myconf=""
    
	myconf="${myconf} --disable-build-dir-test"
	myconf="${myconf} --with-lispdir=${SITELISP}"
	myconf="${myconf} --with-auto-dir=/var/lib/site-lisp/auctex"
	myconf="${myconf} `use_enable preview-latex preview`"

	econf \
	    ${myconf} || die "econf failed"
	
	make all || die
}

src_install () 
{
	make install DESTDIR=${D} || die
    
	# ???
	dosed ${SITELISP}/tex-site.el || die
	
	elisp-site-file-install ${FILESDIR}/${SITEFILE}
	
	elisp-install ${PN} tex-jp.el* || die

	dodoc ChangeLog CHANGES README* INSTALL* FAQ TODO RELEASE

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

	use preview-latex && /usr/bin/mktexlsr
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

# Local Variables:
# mode: sh
# End:
