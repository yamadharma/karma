# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep

MY_PN=Camera
S=${WORKDIR}/${MY_PN}

DESCRIPTION="An Application for displaying and navigating in PDF documents."


HOMEPAGE="http://gna.org/projects/gsimageapps"
SRC_URI="http://download.gna.org/gsimageapps/${MY_PN}-${PV}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="x86 ~ppc"
SLOT="0"

IUSE="${IUSE}"
DEPEND="${GS_DEPEND}
	media-libs/libgphoto2"
RDEPEND="${GS_RDEPEND}"
	
mydoc="Documentation/*"	

src_install ()
{
    egnustep_env
    egnustep_install

    dodoc ${mydoc}
}


# Local Variables:
# mode: sh
# End:

