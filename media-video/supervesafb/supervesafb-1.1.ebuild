# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit patch extrafiles

LRMI_P=0.8

MY_P=${P/-/_}

DESCRIPTION="SuperVESAfb is a FrameBuffer driver for Linux boxes."
HOMEPAGE="http://www.rastersoft.com/supervesafb_en.html"
LICENSE="GPL-2 LGPL-2.1"


IUSE=""

DEPEND="virtual/linux-sources"

SLOT="0"
KEYWORDS="x86"

SRC_URI="http://www.rastersoft.com/programas/${PN}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}


src_compile () 
{
#    addwrite /dev/mem

    cd lrmi-${LRMI_P}
    make

    cd ${S}
    make
}


src_install () 
{
    dosbin fbsetmoded
    dodoc  README LEEME faq.txt
    
    extrafiles_install
}

pkg_postinst () 
{
	einfo
	einfo "Done. Now, go to /usr/src/linux and recompile your kernel,"
	einfo "being sure that you mark the VESA driver option."
	einfo
	einfo "Finally, add the VGA=xxx statement to yout /etc/lilo.conf"
	einfo "and rerun 'lilo' from a command line."
	einfo
}

# Local Variables:
# mode: sh
# End:

