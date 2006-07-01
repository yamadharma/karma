# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_P="systemimager-${PV}"

S=${WORKDIR}/${MY_P}

IUSE=""

DESCRIPTION="System imager client. Software that automates Linux installs, software distribution, and production deployment."
HOMEPAGE="http://www.systemimager.org/"
SRC_URI="mirror://sourceforge/systemimager/${MY_P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64"

DEPEND=""
RDEPEND="${DEPEND}
	~app-admin/systemimager-common-${PV}
	dev-lang/perl
	|| ( sys-apps/util-linux ) ( sys-apps/parted )"

src_compile () 
{
        econf || die "Config error"    
}

src_install () 
{
	einstall install_client DESTDIR=${D}
}

