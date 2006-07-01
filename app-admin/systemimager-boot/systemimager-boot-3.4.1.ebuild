# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic

IUSE="${IUSE}"

MY_P="systemimager-${PV}"

S=${WORKDIR}/${MY_P}
DESCRIPTION="System imager boot-i386. Software that automates Linux installs, software distribution, and production deployment."
HOMEPAGE="http://www.systemimager.org/"
SRC_URI="mirror://sourceforge/systemimager/${MY_P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64"

DEPEND="${DEPEND}"
RDEPEND="${RDEPEND}"

boot_flavor=standard

src_unpack ()
{
    unpack ${A}
    sed -i -e "s://#define BB_DD:#define BB_DD:" ${S}/initrd_source/patches/busybox.Config.h.standard
    sed -i -e "s://#define BB_DD:#define BB_DD:" ${S}/initrd_source/patches/busybox.Config.h.noinsmod
    
    # FIX compilation
    
#    sed -i -e "/.*OPENSSH_.*/d" \
#	    -e "/.*RAIDTOOLS_.*/d" \
#	    -e "/.*raidstart.*/d" \
#	    ${S}/Makefile
}

src_compile () 
{
    unset CFLAGS

    filter-flags -fstack-protector

#    emake kernel || die "Kernel compiling error"
#    make kernel || die "Kernel compiling error"
#    make -f ${S}/initrd_source/initrd.rul INITRD_DIR=${S}/initrd_source || die "Initrd.img compiling error"
#    make boel_binaries_tarball || die "BOEL tarball compiling error"
#    make -i binaries || die "Compiling error"

#    make binaries || die "Compiling error"    
    emake all || die "Compiling error"    
}

src_install () 
{
    einstall DESTDIR=${D} install_binaries || die "Installing error"

    # install_kernel install_initrd 
    # install_boel_binaries_tarball || die "Installing error"
}

