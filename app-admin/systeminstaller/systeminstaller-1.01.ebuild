# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/app-admin/systemimager-server-bin/systemimager-server-bin-3.0.1.ebuild,v 1.1 2003/10/17 12:27:31 bass Exp $

IUSE=""

inherit perl-module

S=${WORKDIR}/${P}

DESCRIPTION="System Installer is an installation tool which is designed to build Linux images"
HOMEPAGE="http://systeminstaller.sourceforge.net/"
SRC_URI="mirror://sourceforge/systeminstaller/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND=">=dev-perl/AppConfig-1.52"

RDEPEND="${DEPEND}"

src_install ()
{
    perl-module_src_install
    mv ${D}/usr/man/man1/* ${D}/usr/share/man/man1/ 
    rm -rf ${D}/usr/man
}