# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/app-gnustep/helpviewer/helpviewer-0.3.ebuild,v 1.2 2003/10/18 20:22:53 raker Exp $

inherit gnustep-app-gui

S=${WORKDIR}/HelpViewer-${PV}

DESCRIPTION="HelpViewer is an online help viewer for GNUstep programs."
HOMEPAGE="http://www.roard.com/helpviewer/"
SRC_URI="http://www.roard.com/helpviewer/download/HelpViewer-${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

mydoc="AUTHORS README"

# Local Variables:
# mode: sh
# End:
