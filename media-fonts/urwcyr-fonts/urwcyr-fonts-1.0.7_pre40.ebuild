# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

FONT_SUPPLIER="urwcyr"
FONT_BUNDLE="base35"

IUSE="X gnustep"

inherit font nfont

MY_PN=urw-fonts

MY_PV=${PV/_/}
MY_P=${MY_PN}-${MY_PV}

DESCRIPTION="Cyrillized free URW fonts"
SRC_URI="ftp://ftp.gnome.ru/fonts/urw/release/${MY_P}.tar.bz2"
HOMEPAGE=""
KEYWORDS="x86 amd64"
LICENSE="GPL-2,LGPL"
SLOT="0"

S="${WORKDIR}"

FONT_FORMAT="type1"

FONT_SUFFIX="afm pfb"

FONT_S="${S}"

DOCS="ChangeLog README* TODO"

src_install ()
{
	font_src_install
	use gnustep && nfont_src_install
}



# Local Variables:
# mode: sh
# End:
