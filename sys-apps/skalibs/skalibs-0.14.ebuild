# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/sys-apps/daemontools/daemontools-0.76-r1.ebuild,v 1.10 2002/10/20 18:54:50 vapier Exp $

S=${WORKDIR}/prog/${P}

DESCRIPTION="Skalibs is a package centralizing the public-domain development files"
SRC_URI="http://www.skarnet.org/software/skalibs/${P}.tar.gz"
HOMEPAGE="http://www.skarnet.org/software/skalibs/index.html"

KEYWORDS="x86 ppc sparc sparc64"
SLOT="0"
LICENSE="freedist"

DEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}
	cd ${S}

	LDFLAGS=
	use static && LDFLAGS="-static"

	echo "gcc ${CFLAGS}" > src/sys/conf-cc
	echo "gcc ${LDFLAGS}" > src/sys/conf-ld
#	echo ${S} > src/sys/home
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
  cd ${S}
  insinto /usr/lib/${PN}/library
  doins library/*
  insinto /usr/lib/${PN}/sysdeps
  doins sysdeps/*
  insinto /usr/include/${PN}
  doins include/*

  cd ${S}
  dodoc package/CHANGES package/README
  dodoc doc/*

}
