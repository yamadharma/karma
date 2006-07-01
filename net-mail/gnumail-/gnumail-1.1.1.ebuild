# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/app-gnustep/gnumail/gnumail-1.1.0.ebuild,v 1.2 2003/10/18 20:14:45 raker Exp $

inherit gnustep-app-gui

IUSE="${IUSE} xface crypt"

S=${WORKDIR}/GNUMail

DESCRIPTION="A fully featured mail application for GNUstep"
HOMEPAGE="http://www.collaboration-world.com/gnumail/"
SRC_URI="http://www.collaboration-world.com/gnumail.data/releases/Stable/GNUMail-${PV}.tar.gz"

DEPEND="${DEPEND}
	gnustep-libs/pantomime"

# crypt? app-crypt/gnupg	
	
RDEPEND="${RDEPEND}"

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


# Local Variables:
# mode: sh
# End:
