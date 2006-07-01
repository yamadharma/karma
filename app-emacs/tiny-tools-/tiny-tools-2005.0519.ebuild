# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE=""

inherit eutils

DESCRIPTION="Emacs Tiny Tools is a collection of libraries and packages"
HOMEPAGE="http://tiny-tools.sourceforge.net"
SRC_URI="mirror://sourceforge/ecf/${P}.tar.bz2"
LICENSE="GPL"
SLOT="0"
KEYWORDS="x86 amd64"

DEPEND="${DEPEND}
	app-editors/emacs
	dev-lang/perl"

SITELISP=/usr/share/site-lisp/common/packages
SITELISPROOT=/usr/share/site-lisp
SITELISPDOC=/usr/share/site-lisp/doc

src_unpack ()
{
    unpack ${A}
    
    cd ${S}/bin
    for i in *.pl 
	do
	mv $i $i-tmp
	echo '#!/usr/bin/perl' > $i
	cat $i-tmp >> $i
	rm $i-tmp
    done
}

src_compile() 
{
    # Sandbox issues
    addpredict "/usr/share/info"

    mkdir -p ${HOME}/tmp
    mkdir -p ${HOME}/elisp

    emake || die
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
    
}

# Local Variables:
# mode: shell-script
# tab-width: 4
# indent-tabs-mode: t
# End:
