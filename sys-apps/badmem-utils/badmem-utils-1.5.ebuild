# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE="doc"

#S=${WORKDIR}/${PN}-v${PV}
S=${WORKDIR}/badmem

DESCRIPTION="Tools to make (partly) buggy memory modules work"
SRC_URI="mirror://sourceforge/badmem/${P}.tar.bz2"
HOMEPAGE="http://badmem.sf.net/"
KEYWORDS="x86"
LICENSE="GPL-2"
SLOT="0"

DEPEND="virtual/glibc"

src_compile ()
{
    cd ${S}/testsuite 
    sed -i -e "s:\$(CC):\$(CC) \$(CFLAGS):g" Makefile.in
    sed -i -e "s:statictest >:./statictest >:g" Makefile.in
    
    cd ${S}/badmemlib 
    sed -i -e "s:/usr/local/\$(i):\$(DESTDIR)/usr/\$(i):g" Makefile.in

    for i in badmemlib badmemcmp badmemmerge badmemshift badmemtype mdfprint testsuite 
      do
      cd ${S}/${i}
      pwd
      sed -i -e "s:/usr/local/bin:\$(DESTDIR)/usr/bin:g" Makefile.in
    done

    
    cd ${S}
    econf \
	|| die "configuration problems"
  
    cd ${S}
    for i in badmemlib badmemcmp badmemmerge badmemshift badmemtype mdfprint testsuite 
      do
      cd ${S}/${i}
      pwd
      make prefix=/usr CFLAGS="-I${S}/badmemlib/include -I. -O3 -L${S}/badmemlib -L../badmemlib -L."
    done
    
    cd ${S}/testsuite
    make run || die "Test failed"
    
#     if ( use doc )
# 	then
# 	for i in howto mdfspec 
# 	  do
# 	  cd ${S}/${i}
# 	  pwd
# 	  make all
# 	done
#     fi
}

src_install () 
{
    dodir /usr/lib
    dodir /usr/bin
    dodir /usr/include
  
    make install prefix=${D}/usr DESTDIR=${D}
    
    dodir /usr/src/kernel-utils
    cd ${D}/usr/src/kernel-utils
    unpack ${A}
    cd ${D}/usr/src/kernel-utils/badmem
    econf
}

# Local Variables:
# mode: sh
# End:

