# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/dev-util/gnustep-gui/gnustep-gui-0.8.7.ebuild,v 1.1 2003/07/13 20:59:40 raker Exp $

inherit gnustep-base

DESCRIPTION="GNUstep AppKit implementation"
HOMEPAGE="http://www.gnustep.org"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/core/${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86 -ppc -sparc"

DEPEND=">=gnustep-base/gnustep-base-1.7.1
	>=media-libs/tiff-3.5.7
	>=media-libs/jpeg-6b-r2
	>=media-libs/audiofile-0.2.3" 
	
PDEPEND="=gnustep-base/gnustep-back-${PV}*"

S=${WORKDIR}/${P}

myconf="--with-jpeg-library=/usr/lib \
	--with-jpeg-include=/usr/include \
	--with-tiff-library=/usr/lib \
	--with-tiff-include=/usr/include"

