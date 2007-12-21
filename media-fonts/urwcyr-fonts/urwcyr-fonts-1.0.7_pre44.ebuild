# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

FONT_SUPPLIER="urwcyr"
FONT_BUNDLE="base35"

inherit font 


MY_PN=urw-fonts

MY_PV=${PV/_/}
MY_P=${MY_PN}-${MY_PV}

TEX_PV="01c"

DESCRIPTION="URW fonts cyrillized by Valek Filippov"
SRC_URI="ftp://ftp.gnome.ru/fonts/urw/release/${MY_P}.tar.bz2"
HOMEPAGE=""
KEYWORDS="x86 amd64"
LICENSE="GPL-2,LGPL,LPPL-1.2"
SLOT="0"

DEPEND="dev-lang/perl"

S="${WORKDIR}"

FONT_FORMAT="type1"

FONT_SUFFIX="afm pfb"

FONT_S="${S}"


# Local Variables:
# mode: sh
# End:
