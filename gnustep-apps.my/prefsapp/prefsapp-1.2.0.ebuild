# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/app-gnustep/terminal/terminal-0.9.4.ebuild,v 1.2 2003/07/28 04:06:48 raker Exp $

inherit gnustep-app-gui

MY_P=Preferences-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="GNUstep preferences editor"
HOMEPAGE="http://sourceforge.net/projects/prefsapp"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

mydoc="README"