# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

WANT_AUTOCONF=latest
WANT_AUTOMAKE=latest
inherit autotools eutils

# Upstream sources use date instead version number
# MY_PV="1.6.2.3"
MY_PV=${PV}

DESCRIPTION="Cairo-dock is yet another dock applet"
HOMEPAGE="http://developer.berlios.de/projects/cairo-dock/"
SRC_URI="http://download2.berlios.de/cairo-dock/cairo-dock-${MY_PV}.tar.bz2"

LICENSE="GPL"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

S="${WORKDIR}"

IUSE="+themes +glitz doc kde gnome xfce compiz-fusion"

DEPEND="media-libs/glitz
	gnome-base/librsvg
	sys-apps/dbus
	dev-libs/dbus-glib
	x11-libs/libXcomposite
	>=dev-libs/glib-2.14.6
	dev-libs/libxml2
	x11-libs/cairo
	kde?	( || ( kde-base/kwin kde-base/kwin:kde-4 ) )
	gnome?	( x11-misc/xcompmgr )
	xfce?	( xfce-base/xfwm4   )
	compiz-fusion?	( || ( x11-wm/compiz-fusion x11-wm/compiz-fusion-git ) )"

PDEPEND=">=x11-misc/cairo-dock-plugins-${PV}
	themes? ( >=x11-misc/cairo-dock-themes-${PV} )"


src_unpack() {
	if ! use glitz; then
		einfo "Enabling the glitz USE flag is recommended."
		einfo "It will improve the performance of cairo-dock."
	fi
	unpack cairo-dock-${MY_PV}.tar.bz2
	cd "${S}/${PN}-${MY_PV}"
	eautoreconf || die "eautoreconf failed at cairo-dock"
	econf || die "econf failed at cairo-dock"
}

src_compile() {
	cd "${S}/${PN}-${MY_PV}"
	emake || die "emake failed at cairo-dock"
}

src_install() {
	cd "${S}/${PN}-${MY_PV}"
	emake DESTDIR="${D}" install || die "emake install failed at cairo-dock"
	if use doc; then
		dodoc ANNOUNCE AUTHORS ChangeLog NEWS README* TODO
	fi
}
