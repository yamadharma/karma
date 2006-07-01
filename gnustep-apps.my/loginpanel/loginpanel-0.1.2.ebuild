# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/dev-util/gnustep-back/gnustep-back-0.8.0.ebuild,v 1.2 2002/12/09 04:21:15 manson Exp $

inherit gnustep-app-gui

DESCRIPTION="GNUstep Login Panel"
HOMEPAGE="http://www.gnustep.org"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/usr-apps/${P}.tar.gz"
LICENSE="LGPL"
SLOT="0"
KEYWORDS="x86 -ppc -sparc "
DEPEND="${DEPEND}
	gnustep-libs/gscrypt-cvs
	x11-base/xfree"
S=${WORKDIR}/${PN}

mydocs="README*"
