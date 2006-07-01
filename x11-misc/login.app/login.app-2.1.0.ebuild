# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/x11-misc/wdm/wdm-1.22.ebuild,v 1.1 2003/02/19 07:14:55 bcowan Exp $

IUSE=""

inherit patch

SUB_V="-Alpha-3"
MY_P=Login.app-${PV}${SUB_V}

DESCRIPTION="XDM like graphical login program"
HOMEPAGE="http://largo.windowmaker.org/Login.app"
SRC_URI="http://largo.windowmaker.org/files/Login.app/${MY_P}.tar.gz"


SLOT="0"
KEYWORDS="x86"
LICENSE="GPL-2"

RDEPEND=">=x11-wm/windowmaker-0.65.1"

DEPEND="${RDEPEND}
	gnustep-base/gnustep-make"

S=${WORKDIR}/${MY_P}

src_unpack ()
{
    patch_src_unpack
    ./reconf
}


src_compile () 
{
	local myconf=""

	econf \
	    ${myconf} || die
		
	emake || die
}

src_install () 
{
	make \
	    DESTDIR=${D} \
	    install || die
}


# Local Variables:
# mode: sh
# End:

