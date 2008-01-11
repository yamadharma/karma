# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A Flexible Indexing System"

HOMEPAGE="http://www.xindy.org/"
SRC_URI="mirror://sourceforge/xindy/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="doc"
# IUSE="doc clisp"
DEPEND="virtual/latex-base"
#	clisp? ( dev-lisp/clisp )

src_compile() {
	local myconf
	local clisp_dir

#	if ( use clisp ) 
#	then
#	    clisp_dir=`clisp  --version | grep "Installation directory:" | sed 's/Installation directory: //'`
#	    myconf="${myconf} --enable-external-clisp --enable-clisp-dir=${clisp_dir}"
#	    
#	fi
	
	
	LDFLAGS="" \
	econf \
	    `use_enable doc docs` \
	    ${myconf} \
	    || die "Configure failed"
	make -j1 || die "Make failed"
}


src_install() {
	make install \
	    DESTDIR=${D} || die "Install failed"
}

