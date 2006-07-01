# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="XTerm wrapper with koi8-r locale"
HOMEPAGE="ftp://invisible-island.net/xterm/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc ~alpha ~mips ~arm ~hppa amd64 ~ia64 ~ppc64"
IUSE=""

S=${WORKDIR}

RDEPEND="x11-terms/xterm
	media-fonts/terminus-font"

src_install () 
{
    dobin ${FILESDIR}/koi8-term
    
    insinto /etc/X11/app-defaults/
    doins ${FILESDIR}/KOI8Term
}
