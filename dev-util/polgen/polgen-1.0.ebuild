# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="This package contains polgen, a collection of scripts and tools
developed by the MITRE corporation to automate the SELinux
policy generation process."

SRC_URI="http://ccache.samba.org/ftp/ccache/${P}.tar.gz"
HOMEPAGE="http://ccache.samba.org/"

IUSE="doc selinux"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64 ~ppc ~sparc ~alpha ~hppa"

DEPEND=">=dev-lang/python-2.2.3
	selinux? ( sys-libs/libselinux )"

RDEPEND="${DEPEND}"


src_compile () 
{
	local myconf
	
	if ( ! use selinux ) 
	    then
	    myconf="${myconf} --with-strace=no"
	fi	    
	
	econf ${myconf} || die
	emake || die
}

src_install () 
{
	einstall || die
	
	dodoc AUTHORS ChangeLog COPYING INSTALL NEWS README
	
	if ( use doc )
	    then
	    dohtml ${S}/doc/*.html
	    cd ${S}/doc
	    make ps
	    make pdf
	    dodoc *.ps *.pdf
	fi
}

