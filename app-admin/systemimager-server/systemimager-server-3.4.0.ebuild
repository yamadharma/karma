# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

IUSE="${IUSE} doc"

MY_P="systemimager-${PV}"

S=${WORKDIR}/${MY_P}
DESCRIPTION="System imager boot-i386. Software that automates Linux installs, software distribution, and production deployment."
HOMEPAGE="http://www.systemimager.org/"
SRC_URI="mirror://sourceforge/systemimager/${MY_P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND="${DEPEND}
	doc?	app-text/dos2unix"
RDPEND="${DEPEND}"


src_compile () 
{
    make binaries
}

src_install () 
{
    make DESTDIR=${D} install_server
}

