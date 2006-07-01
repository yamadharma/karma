# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep

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
    newdepend	"gnustep-libs/smbkit"
fi

S_ADD="${S_ADD} ClipBook GWRemote"

src_compile () 
{
	egnustep_env

	econf || die "configure failed"

	egnustep_make
}


# Local Variables:
# mode: sh
# End:
