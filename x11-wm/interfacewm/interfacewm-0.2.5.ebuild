# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/x11-wm/WindowMaker/WindowMaker-0.80.2.ebuild,v 1.3 2002/11/18 06:49:54 blizzy Exp $

inherit gnustep-app-gui

IUSE=""


S=${WORKDIR}/${P}

DESCRIPTION="The fast and light GNUstep window manager"
SRC_URI="mirror://sourceforge/interfacewm/interface-${PV}.tgz"
HOMEPAGE="http://interfacewm.sf.net/"

DEPEND="virtual/x11
	media-libs/hermes
	>=media-libs/tiff-3.5.5
	gif? ( >=media-libs/giflib-4.1.0-r3 
		>=media-libs/libungif-4.1.0 )
	png? ( >=media-libs/libpng-1.2.1 )
	jpeg? ( >=media-libs/jpeg-6b-r2 )"

RDEPEND="nls? ( >=sys-devel/gettext-0.10.39 )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc sparc64 alpha"

