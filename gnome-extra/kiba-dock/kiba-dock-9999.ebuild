# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils gnome2 subversion

ESVN_REPO_URI="https://kibadock.svn.sourceforge.net/svnroot/kibadock/trunk/${PN}"

S="${WORKDIR}/${PN/-/}"

DESCRIPTION="Funny dock with support for the akamaru physics engine"
HOMEPAGE="http://kiba-dock.org"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="akamaru glitz svg"

PDEPEND="gnome-extra/kiba-plugins"

DEPEND="
	>=dev-libs/glib-2.8
	dev-libs/libxml2
	>=gnome-base/gnome-desktop-2.8
	>=x11-libs/gtk+-2.8
	>=x11-libs/pango-1.10
	akamaru? ( gnome-extra/akamaru )
	glitz? ( >=media-libs/glitz-0.4 )
	svg? ( gnome-base/librsvg )
"

pkg_setup() {
	if use svg && ! built_with_use x11-libs/cairo svg ; then
		eerror "Please rebuild cairo with USE=\"svg\""
		die "rebuild cairo with USE=\"svg\""
	fi
}

src_unpack() {
	subversion_src_unpack
	cd "${S}"

	intltoolize --force --copy || die "intltoolize failed"
	eautoreconf || die "eautoreconf failed"
}

src_compile() {
	G2CONF="${G2CONF} $(use_enable glitz) $(use_enable svg) $(use_enable akamaru)"

	gnome2_src_compile
}

pkg_postinst() {
	einfo
	einfo "If you have an ati or nvidia card, you should disable the glitz"
	einfo "support in kiba-dock and kiba-plugins. That should prevent a"
	einfo "segmentation fault when starting kiba-dock with ati cards and"
	einfo "colour artifacts or invisible dock with nvidia cards."
	einfo
	einfo "To add launchers, run /usr/bin/populate-dock.sh"
	einfo "or drag shortcuts (from gnome-menu for example) onto the dock"
	einfo
	einfo "DO NOT report bugs to Gentoo's bugzilla"
	einfo "Please report all bugs to #gentoo-desktop-effects"
	einfo "Thank you on behalf of the Gentoo Desktop-Effects team"

	gnome2_pkg_postinst
}
