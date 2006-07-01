# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep

S=${WORKDIR}/${P/c/C}

DESCRIPTION="Free software and romantic music player for GNUstep."
HOMEPAGE="http://organact.mine.nu/~wolfgang/cynthiune"
SRC_URI="http://organact.mine.nu/~wolfgang/cynthiune/${P/c/C}.tar.gz"

IUSE="${IUSE} oggvorbis mikmod flac esd"

KEYWORDS="x86"
LICENSE="GPL-2"
SLOT="0"

DEPEND="${GS_DEPEND}
	media-libs/libid3tag
	media-libs/libmad
	oggvorbis? ( media-libs/libogg
	    media-libs/libvorbis )
	mikmod? ( media-plugins/modplugxmms )
	flac? ( media-libs/flac )
	esd? ( media-sound/esound )"
RDEPEND="${GS_RDEPEND}"

mydoc="TODO README ChangeLog NEWS"

src_install ()
{
    egnustep_env
    egnustep_install

    dodoc ${mydoc}
}

# Local Variables:
# mode: sh
# End:

