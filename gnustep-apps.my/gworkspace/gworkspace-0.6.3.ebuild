# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/app-gnustep/gworkspace/gworkspace-0.5.3.ebuild,v 1.1 2003/07/15 08:09:24 raker Exp $

inherit gnustep-app-gui

IUSE="${IUSE} samba"

S=${WORKDIR}/GWorkspace-${PV}

DESCRIPTION="GWorkspace is the official GNUstep workspace manager"
HOMEPAGE="http://www.gnustep.it/enrico/gworkspace"
SRC_URI="http://www.gnustep.it/enrico/gworkspace/${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86"

if [ `use samba` ]
    then
    S_ADD="GWNet"
    newdepend	"gnustep-libs/smbkit-cvs"
fi

S_ADD="${S_ADD} ClipBook GWRemote"

# Local Variables:
# mode: sh
# End:
