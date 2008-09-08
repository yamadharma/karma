# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/btnx/btnx-config-0.4.8.ebuild $ 

# btnx-config-VER	-> normal btnx-config release

DESCRIPTION="(necessary) GUI to configure btnx"
HOMEPAGE="http://www.ollisalonen.com/btnx/"
SRC_URI="http://www.ollisalonen.com/btnx/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64" # not tested on other systems
IUSE=""

# depends on btnx, libglade, libgtk2
# Hint: I made a portage overly and copied the ebuild for btnx to app-misc/btnx, 
# because of the dependecies you have to do it too or correct the path to btnx
DEPEND=">=app-misc/btnx-0.4.7
	>=gnome-base/libglade-2.6.0
        >=dev-util/pkgconfig-0.21
        >=x11-libs/gtk+-2.10.11" 
       	#and website: needs "built-essential". What does this mean? It works for me without this.


src_unpack() {
		unpack ${A}
		cd "${S}"
}

src_compile() {
		econf || die "econf failed"
		emake || die "emake failed"
}
src_install() {
		emake DESTDIR="${D}" install || die "emake install failed."
}
