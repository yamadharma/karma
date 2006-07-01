# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit patch extrafiles

IUSE="${IUSE}"

MY_P="systemimager-${PV}"

S=${WORKDIR}/${MY_P}
DESCRIPTION="System imager boot-i386. Software that automates Linux installs, software distribution, and production deployment."
HOMEPAGE="http://www.systemimager.org/"
SRC_URI="mirror://sourceforge/systemimager/${MY_P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND="${DEPEND}"
RDEPEND="${RDEPEND}
	!app-admin/systemimager-boot-bin"


src_compile () 
{
    unset CFLAGS

    filter-flags -fstack-protector

#    make kernel || die "Kernel compiling error"
    make -i binaries || die "Compiling error"
    make binaries || die "Compiling error"    
}

src_install () 
{
    make DESTDIR=${D} install_binaries || die "Installing error"
}

