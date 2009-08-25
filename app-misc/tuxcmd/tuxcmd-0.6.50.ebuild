# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Tux Commander - Fast and Small filemanager using GTK2"
HOMEPAGE="http://tuxcmd.sourceforge.net/"
SRC_URI="mirror://sourceforge/tuxcmd/tuxcmd-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64" # FreePascal restrictions
RESTRICT="strip binchecks"
PROVIDE="app-misc/tuxcmd-bin"

DEPEND=""
RDEPEND=">=x11-libs/gtk+-2.4.0
	 >=dev-libs/glib-2.16.0
	 >=x11-libs/pango-1.4.0
	 >=dev-lang/fpc-2.2.0"


src_compile() {
        emake || die "emake failed"
}

src_install() {
        emake DESTDIR="${D}/usr" install || die "emake install failed"

	# copy icon and desktop entry
        insinto /usr/share/pixmaps
        doins ${FILESDIR}/tuxcmd.png
        domenu ${FILESDIR}/tuxcmd.desktop
}
