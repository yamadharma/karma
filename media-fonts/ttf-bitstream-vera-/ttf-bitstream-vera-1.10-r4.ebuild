# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/ttf-bitstream-vera/ttf-bitstream-vera-1.10-r3.ebuild,v 1.1 2004/05/31 14:24:24 foser Exp $

FONT_SUPPLIER="bitstream"
FONT_BUNDLE="vera"

inherit gnome.org fonts

IUSE="${IUSE}"

DESCRIPTION="Bitstream Vera font family"
HOMEPAGE="http://www.gnome.org/fonts/"
LICENSE="BitstreamVera"

SLOT="0"
KEYWORDS="x86 ~ppc ~sparc ~alpha ~mips ~amd64 ~hppa ~ia64"


FONT_FORMAT="ttf"

INSTALL_TARGET="x"

mydoc="COPYRIGHT.TXT README.TXT RELEASENOTES.TXT"

# Local Variables:
# mode: sh
# End:
