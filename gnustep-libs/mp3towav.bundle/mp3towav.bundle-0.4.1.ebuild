# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/gworkspace/gworkspace-0.7.1.ebuild,v 1.1 2005/04/15 04:35:57 fafhrd Exp $

inherit gnustep

S=${WORKDIR}/MP3ToWav

DESCRIPTION="MP3ToWav.bundle is a supportig bundle for Burn.app."
HOMEPAGE="http://gsburn.sf.net"
SRC_URI="mirror://sourceforge/gsburn/mp3towav-${PV}.tar.gz"

KEYWORDS="x86 amd64"
LICENSE="GPL-2"
SLOT="0"

IUSE="${IUSE}"
DEPEND="${GS_DEPEND}"
RDEPEND="${GS_RDEPEND}"

egnustep_install_domain "System"

src_install ()
{
    gnustep_src_install
    
    cd ${S}
    dodoc README
}

