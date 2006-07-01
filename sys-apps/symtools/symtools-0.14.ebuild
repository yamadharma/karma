# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/sys-apps/daemontools/daemontools-0.76-r1.ebuild,v 1.10 2002/10/20 18:54:50 vapier Exp $

S=${WORKDIR}/admin/${P}

DESCRIPTION="Symtools is a set of tools designed to gracefully handle symbolic links"
SRC_URI="http://www.skarnet.org/software/symtools/${P}.tar.gz"
HOMEPAGE="http://www.skarnet.org/software/symtools/index.html"

KEYWORDS="x86 ppc sparc sparc64"
SLOT="0"
LICENSE="freedist"

DEPEND=">=sys-apps/skalibs-0.13
	virtual/glibc"
RDEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}
	cd ${S}

	LDFLAGS=
	use static && LDFLAGS="-static"

	echo "gcc ${CFLAGS}" > src/sys/conf-cc
	echo "gcc ${LDFLAGS}" > src/sys/conf-ld
#	echo ${S} > src/sys/home
  
  echo "/usr/include/skalibs" 	> package/import
  echo "/usr/lib/skalibs/library" >> package/import
  echo "/usr/lib/skalibs/sysdeps" >> package/import
}

src_compile() 
{
  cd ${S}
  package/compile || die "make failed"
#  package/upgrade || die "make failed"
#  package/compat  || die "make failed"

}

src_install() 
{

  einfo "Installing package ..."
  cd ${S}/command
  exeinto /usr/bin
  doexe linkname update-symlinks
  dosym /usr/bin/linkname /usr/bin/readlink

  cd ${S}
  dodoc package/CHANGES package/README package/THANKS package/TODO
  cd ${S}
  dodoc doc/*

}
