# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit patch


LRMI_P=0.8

MY_P=${P/-/_}

DESCRIPTION="SuperVESAfb is a FrameBuffer driver for Linux boxes."
HOMEPAGE="http://www.rastersoft.com/supervesafb_en.html"
LICENSE="GPL-2 LGPL-2.1"


IUSE=""

DEPEND="virtual/linux-sources"

SLOT="0.9"
KEYWORDS="x86 ~ppc"

SRC_URI="http://www.rastersoft.com/programas/${PN}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}


src_compile () 
{
# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit patch


LRMI_P=0.8

MY_P=${P/-/_}

DESCRIPTION="SuperVESAfb is a FrameBuffer driver for Linux boxes."
HOMEPAGE="http://www.rastersoft.com/supervesafb_en.html"
LICENSE="GPL-2 LGPL-2.1"


IUSE=""

DEPEND="virtual/linux-sources"

SLOT="0.9"
KEYWORDS="x86 ~ppc"

SRC_URI="http://www.rastersoft.com/programas/${PN}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}


src_compile () 
{
    addwrite /dev/mem

    cd ${S}
    cd lrmi-${LRMI_P}
    make
    cd ${S}
    make findmodes

    ./findmodes || exit 1;

