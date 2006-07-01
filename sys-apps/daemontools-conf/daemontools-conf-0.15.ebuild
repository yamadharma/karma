# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/sys-apps/daemontools/daemontools-0.76-r1.ebuild,v 1.10 2002/10/20 18:54:50 vapier Exp $

S=${WORKDIR}/admin/${P}

DESCRIPTION="Configuration package for daemontools"
SRC_URI="http://js.hu/package/daemontools-conf/${P}.tar.gz"
HOMEPAGE="http://js.hu/package/daemontools-conf.html"

KEYWORDS="x86 ppc sparc sparc64"
SLOT="0"
LICENSE="freedist"

DEPEND=">=sys-apps/daemontools-0.70
	>=sys-apps/skalibs-0.13
	>=sys-apps/symtools-0.14
	virtual/glibc"
RDEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}
	cd ${S}

	LDFLAGS=
	use static && LDFLAGS="-static"

	echo "gcc ${CFLAGS}" > src/conf-cc
	echo "gcc ${LDFLAGS}" > src/conf-ld
#	echo ${S} > src/sys/home
  
#  echo "/usr/include/skalibs" 	> package/import
#  echo "/usr/lib/skalibs/library" >> package/import
#  echo "/usr/lib/skalibs/sysdeps" >> package/import
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
  for x in `cat ../package/commands`
  do
    doexe $x
  done

  cd ${S}/package
  dodoc README
#  cd ${S}
#  dodoc doc/*

}
