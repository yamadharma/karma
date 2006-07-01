# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/dev-util/gnustep-guile/gnustep-guile-1.1.1.ebuild,v 1.2 2003/07/15 08:08:39 raker Exp $

inherit gnustep-app

DESCRIPTION="GNUstep Guile bridge"
HOMEPAGE="http://www.gnustep.org"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/libs/${P}.tar.gz"
LICENSE="LGPL-2.1,GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc"

DEPEND=">=dev-util/guile-1.6"
	
RDEPEND="virtual/glibc"

mydoc="ANNOUNCE COPYING COPYING.LIB ChangeLog INSTALL NEWS README"



