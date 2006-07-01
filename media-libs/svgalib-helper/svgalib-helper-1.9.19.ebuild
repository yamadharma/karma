# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/media-libs/svgalib/svgalib-1.9.18-r1.ebuild,v 1.3 2004/05/12 12:30:06 pappy Exp $

inherit flag-o-matic kmod 

DESCRIPTION="A kernel module for svgalib"
HOMEPAGE="http://www.svgalib.org/"
SRC_URI="http://www.arava.co.il/matan/svgalib/svgalib-${PV}.tar.gz"

S=${WORKDIR}/svgalib-${PV}/kernel/svgalib_helper

LICENSE="BSD"
SLOT="${KV}"
KEYWORDS="-* x86"
IUSE=""

DEPEND=""

check_KV
if [ "${KV_MINOR}" != "4" ] 
    then
    RESTRICT=nouserpriv
fi

src_unpack ()
{
    check_KV
    unpack ${A}
}


# Local Variables:
# mode: sh
# End:

