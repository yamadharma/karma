# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: $

IUSE="tcltk java"

S=${WORKDIR}/${P}
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
    
    cd dist
	
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
    cd dist
    
    make prefix=${D}/usr install || die
#    einstall || die

    for fname in ${D}/usr/bin/db_*
      do
      mv ${fname} ${fname//\/db_/\/db${SLOT}_}
    done

    dodir /usr/include/db${SLOT}
    mv ${D}/usr/include/*.h ${D}/usr/include/db${SLOT}/
    
    dodir /usr/share/doc/${PF}/html
    mv ${D}/usr/docs/* ${D}/usr/share/doc/${PF}/html/
    rm -rf ${D}/usr/docs
    
    dosym /usr/include/db${SLOT}/db.h /usr/include/db.h
}

fix_so () 
{
    cd ${ROOT}/usr/lib
    target=`find -type f -maxdepth 1 -name "libdb-*.so" |sort |tail -n 1`
    [ -n "${target}" ] && ln -sf ${target//.\//} libdb.so
    target=`find -type f -maxdepth 1 -name "libdb_cxx*.so" |sort |tail -n 1`
    [ -n "${target}" ] && ln -sf ${target//.\//} libdb_cxx.so
    target=`find -type f -maxdepth 1 -name "libdb_tcl*.so" |sort |tail -n 1`
    [ -n "${target}" ] && ln -sf ${target//.\//} libdb_tcl.so
    target=`find -type f -maxdepth 1 -name "libdb_java*.so" |sort |tail -n 1`
    [ -n "${target}" ] && ln -sf ${target//.\//} libdb_java.so
    
    cd ${ROOT}/usr/include
    target=`ls -d db? |sort|tail -n 1`
    [ -n "${target}" ] && ln -sf ${target}/db.h .
    [ -n "${target}" ] && ln -sf ${target}/db_185.h .
}

pkg_postinst () 
{
    fix_so
}

pkg_postrm () 
{
    fix_so
}



# Local Variables:
# mode: sh
# End:
