# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Emacs Tiny Tools is a collection of libraries and packages"
HOMEPAGE="http://tiny-tools.sourceforge.net"
SRC_URI="mirror://sourceforge/ecf/${P}.tar.bz2"
LICENSE="GPL"
SLOT="0"
KEYWORDS="x86 amd64"

IUSE=""

DEPEND="${DEPEND}
	|| ( virtual/emacs virtual/xemacs )
	dev-lang/perl"

RDEPEND="${DEPEND}"

SITELISP=/usr/share/site-lisp/common/packages
SITELISPROOT=/usr/share/site-lisp
SITELISPDOC=/usr/share/site-lisp/doc

src_compile() 
{
	# Sandbox issues
	addpredict "/usr/share/info"

	mkdir -p ${HOME}/tmp
	mkdir -p ${HOME}/elisp

	make || die
}

src_install() 
{
    
	make install DESTDIR=${D}
    
	cd ${S}
	for i in bin doc lisp
	do
	    newdoc $i/ChangeLog ChangeLog.$i
	done

	cd ${S}/doc
	dohtml -r html/*

	docinto txt
	dodoc txt/*
    
	if [ -n "$ELISP_DISABLE_ELC" ]
	    then
	    cd ${D}
	    for i in `find . -name '*.elc' -print`
	    do
		rm -f $i
	    done
	fi
}

# Local Variables:
# mode: shell-script
# tab-width: 4
# indent-tabs-mode: t
# End:
