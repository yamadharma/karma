# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/app-gnustep/terminal/terminal-0.9.4.ebuild,v 1.2 2003/07/28 04:06:48 raker Exp $

inherit gnustep-app-gui

S=${WORKDIR}/${P/t/T}
A=${P/t/T}.tar.gz

DESCRIPTION="GNUstep terminal emulator"
HOMEPAGE="http://www.nongnu.org/terminal/"
SRC_URI="http://savannah.nongnu.org/download/terminal/Terminal.pkg/${PV}/${P/t/T}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

mydoc="README"