# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/app-gnustep/imageviewer/imageviewer-0.6.2.ebuild,v 1.1 2003/07/17 14:55:53 brain Exp $

inherit gnustep-app-gui

S=${WORKDIR}/GSDefaults
MY_P=GSDefaults-${PV}

DESCRIPTION="User default database editor for GNUstep"
HOMEPAGE="http://www.nice.ch/~phip/softcorner.html"
SRC_URI="http://www.nice.ch/~phip/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

mydoc="README"