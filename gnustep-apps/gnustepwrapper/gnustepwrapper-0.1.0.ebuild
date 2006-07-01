# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep

MY_PN=GNUstepWrapper
S=${WORKDIR}/${MY_PN}-${PV}

DESCRIPTION="An Application for displaying and navigating in PDF documents."


HOMEPAGE="ftp://ftp.raffael.ch/software/GNUstepWrapper/"
SRC_URI="ftp://ftp.raffael.ch/software/GNUstepWrapper/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="x86 ~ppc"
SLOT="0"

IUSE="${IUSE}"
DEPEND="${GS_DEPEND}"
RDEPEND="${GS_RDEPEND}"

mydoc="AUTHORS NEWS README TODO"	

src_install ()
{
    egnustep_env
    egnustep_install

    dodoc ${mydoc}
}

# Local Variables:
# mode: sh
# End:

