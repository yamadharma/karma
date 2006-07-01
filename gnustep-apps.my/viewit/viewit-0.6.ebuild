# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/app-gnustep/imageviewer/imageviewer-0.6.2.ebuild,v 1.1 2003/07/17 14:55:53 brain Exp $

inherit gnustep-app-gui

IUSE="${IUSE}"

MY_P=ViewIt-${PV}
S=${WORKDIR}/${MY_P}

DEPEND="${DEPEND}
	virtual/ghostscript"

DESCRIPTION="GNUstep application to display the contents of documents of various types"
HOMEPAGE="http://mac.wms-network.de/gnustep/viewit/viewit.html"
SRC_URI="http://mac.wms-network.de/gnustep/viewit/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

mydoc="CHANGES README"