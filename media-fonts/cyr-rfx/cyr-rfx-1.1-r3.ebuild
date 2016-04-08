# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2

FONT_SUPPLIER="urw"
FONT_BUNDLE="base35"

inherit fonts

IUSE="${IUSE}"

S=${WORKDIR}
DESCRIPTION="CYRillic Raster Fonts for X"
HOMEPAGE="http://www.inp.nsk.su/~bolkhov/files/fonts/cyr-rfx/00index.en.html"
SRC_URI="http://www.inp.nsk.su/~bolkhov/files/fonts/cyr-rfx/${PN}-koi8-1-${PV}.tgz
	http://www.inp.nsk.su/~bol# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2

FONT_SUPPLIER="urw"
FONT_BUNDLE="base35"

inherit fonts

IUSE="${IUSE}"

S=${WORKDIR}
DESCRIPTION="CYRillic Raster Fonts for X"
HOMEPAGE="http://www.inp.nsk.su/~bolkhov/files/fonts/cyr-rfx/00index.en.html"
SRC_URI="http://www.inp.nsk.su/~bolkhov/files/fonts/cyr-rfx/${PN}-koi8-1-${PV}.tgz
	http://www.inp.nsk.su/~bolkhov/files/fonts/cyr-rfx/${PN}-koi8-ru-${PV}.tgz
	http://www.inp.nsk.su/~bolkhov/files/fonts/cyr-rfx/${PN}-windows-1251-${PV}.tgz
	http://www.inp.nsk.su/~bolkhov/files/fonts/cyr-rfx/${PN}-iso8859-5-${PV}.tgz
	http://www.inp.nsk.su/~bolkhov/files/fonts/cyr-rfx/${PN}-koi8-ub-${PV}.tgz
	http://www.inp.nsk.su/~bolkhov/files/fonts/cyr-rfx/${PN}-koi8-o-${PV}.tgz
	http://www.inp.nsk.su/~bolkhov/files/fonts/cyr-rfx/${PN}-ibm-cp866-${PV}.tgz
	http://www.inp.nsk.su/~bolkhov/files/fonts/cyr-rfx/${PN}-bulgarian-mik-${PV}.tgz
	http://www.inp.nsk.su/~bolkhov/files/fonts/cyr-rfx/${PN}-iso10646-0400-${PV}.tgz
	http://www.inp.nsk.su/~bolkhov/files/fonts/cyr-rfx/${PN}-winlatin-1-${PV}.tgz
	http://www.inp.nsk.su/~bolkhov/files/fonts/cyr-rfx/${PN}-iso8859-15-${PV}.tgz"

LICENSE="AS IS"
SLOT="0"
KEYWORDS="~x86 sparc sparc64 ppc"

FONT_FORMAT="pcf"

S_FO