# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-app-gui

IUSE="${IUSE} xface crypt"

S=${WORKDIR}/GNUMail

DESCRIPTION="A fully featured mail application for GNUstep"
HOMEPAGE="http://www.collaboration-world.com/gnumail/"
SRC_URI="http://www.collaboration-world.com/gnumail.data/releases/Stable/GNUMail-${PV}.tar.gz"

DEPEND="${DEPEND}
	gnustep-libs/pantomime
	gnustep-apps/addresses"

# crypt? app-crypt/gnupg	
	
RDEPEND="${RDEPEND}
	gnustep-libs/pantomime
	gnustep-apps/addresses"

KEYWORDS="x86 ~ppc"
LICENSE="GPL-2"
SLOT="0"

mydoc="docs/* Goodies/*"

S_ADD="Bundles/Emoticon Bundles/Clock"

if ( use xface )
    then
    S_ADD="${S_ADD} Bundles/Face"
fi

if ( use crypt )
    then
    S_ADD="${S_ADD} Bundles/PGP"
fi

patch_OPTIONS="cleancvs"

# Local Variables:
# mode: sh
# End:
