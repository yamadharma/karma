# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: $

IUSE="tcltk java"

S=${WORKDIR}/${P}/build_unix
DESCRIPTION="Berkeley DB"

SRC_URI="http://www.sleepycat.com/update/snapshot/${P}.tar.gz"
HOMEPAGE="http://www.sleepycat.com"
SLOT="4.1"
LICENSE="DB"
KEYWORDS="~x86 ~ppc ~sparc ~sparc64"

DEPEND="tcltk? ( dev-lang/tcl )
	java? ( virtual/jdk )"

DEPEND="$RDEPEND =sys-libs/db-1.85-r1"

src_compile () 
{
    local myconf
    
    myconf="${myconf} --enable-compat185 --enable-dump185"
    myconf="${myconf} `use_enable java`"

    use tcltk \
    	&& myconf="${myconf} --enable-tcl --with-tcl=/usr/lib" \
    	|| myconf="${myconf} --disable-tcl"

    if [ -n "${JAVAC}" ]; 
	then
    	export PATH=`dirname ${JAVAC}`:${PATH}
	export JAVAC=`basename ${JAVAC}`
    fi
    
    cd ../dist
	
    ./configure \
	--host=${CHOST} \
	--prefix=/usr \
	--mandir=/usr/share/man \
	--infodir=/usr/share/info \
	--datadir=/usr/share \
	--sysconfdir=/etc \
	--localstatedir=/var/lib \
	--enable-cxx \
	--with-uniquename \
	|| die
    
    emake || make || die
}

src_install () 
{
    einstall || die

    db_src_install_usrbinslot

    db_src_install_headerslot

    db_src_install_doc

    db_src_install_usrlibcleanup
}

pkg_postinst () 
{
    db_fix_so
}

pkg_postrm () 
{
    db_fix_so
}

# Local Variables:
# mode: sh
# End:
