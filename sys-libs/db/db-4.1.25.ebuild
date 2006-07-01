# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /home/cvsroot/gentoo-x86/sys-libs/db/db-4.0.14.ebuild,v 1.8 2002/08/14 04:06:42 murphy Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Berkeley DB"

SRC_URI="http://www.sleepycat.com/update/snapshot/${P}.tar.gz"
HOMEPAGE="http://www.sleepycat.com"
SLOT="4.1"
LICENSE="DB"
KEYWORDS="x86 ~ppc ~sparc ~sparc64"

RDEPEND="virtual/glibc"
DEPEND="$RDEPEND =sys-libs/db-1.85-r1"

src_compile() {
  local myconf
  myconf="${myconf} --enable-compat185 --enable-dump185"
	cd dist
	
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		--enable-cxx \
		|| die
	emake || die
}

src_install () 
{
  cd dist

  make prefix=${D}/usr install || die
	
  dodir /usr/share/doc/${PF}/html
  mv ${D}/usr/docs/* ${D}/usr/share/doc/${PF}/html/
  rm -rf ${D}/usr/docs
	
  dodir usr/include/db/${SLOT}
  cd ${D}/usr/include
  mv *.h db/${SLOT}
#  ln db3/db.h db.h

#  cd ${D}/usr/include/db/${SLOT}
#  for i in *.h;
#  do
#    dosym  /usr/include/db/${SLOT}/$i /usr/include/$i
#  done

}
