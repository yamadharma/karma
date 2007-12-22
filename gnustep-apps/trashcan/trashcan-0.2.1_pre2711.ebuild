# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit etoile-svn

S1=${S}/Services/Private/TrashCan

DESCRIPTION="TrashCan is a trash can implementation of freedesktop trash specification."
HOMEPAGE="http://www.etoile-project.org"
#SRC_URI=""
LICENSE="GPL-2"
KEYWORDS="~ppc x86 amd64"
SLOT="0"

IUSE=""
DEPEND="${GS_DEPEND}
	gnustep-libs/xwindowserverkit
	|| ( ( 	x11-libs/libXt
		)
		virtual/x11
	)"
RDEPEND="${GS_RDEPEND}
	gnustep-libs/xwindowserverkit
	|| ( ( 	x11-libs/libXt
		)
		virtual/x11
	)"
