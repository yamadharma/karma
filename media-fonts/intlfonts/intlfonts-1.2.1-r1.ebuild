# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit fonts

IUSE="X"

DESCRIPTION="International X11 fixed fonts"
HOMEPAGE="http://www.gnu.org/directory/intlfonts.html"
SRC_URI="ftp://ftp.gnu.org/pub/gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="x86 ~ppc amd64"

FONT_FORMAT="bdf2pcf"

INSTALL_TARGET="x"

mydoc="ChangeLog NEWS README Emacs.ap"

S_FONTS_bdf2pcf="European Asian Chinese Japanese Ethiopic Misc Chinese.X Japanese.X Korean.X European.BIG Chinese.BIG Japanese.BIG"

