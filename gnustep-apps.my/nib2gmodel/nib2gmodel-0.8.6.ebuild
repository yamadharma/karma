# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-app-gui

S=${WORKDIR}/${P}

DESCRIPTION="GNUstep GUI interface designer"
HOMEPAGE="http://www.gnustep.org"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/dev-apps/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86"

maydoc="ANNOUNCE ChangeLog INSTALL NEWS README"

#src_compile ()
#{
#    econf
#    gnustep-app-gui_src_compile
#}