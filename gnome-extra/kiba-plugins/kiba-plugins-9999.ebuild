# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools eutils gnome2 subversion

ESVN_REPO_URI="https://kibadock.svn.sourceforge.net/svnroot/kibadock/trunk/${PN}"

S="${WORKDIR}/${PN/-/}"

DESCRIPTION="Kiba Dock Plugins"
HOMEPAGE="http://kiba-dock.org"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="glitz svg"

DEPEND="
	gnome-base/gnome-vfs
	gnome-base/libgtop
	gnome-extra/kiba-dock# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools eutils gnome2 subversion

ESVN_REPO_URI="https://kibadock.svn.sourceforge.net/svnroot/kibadock/trunk/${PN}"

S="${WORKDIR}/${PN/-/}"

DESCRIPTION="Kiba Dock Plugins"
HOMEPAGE="http://kiba-dock.org"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="glitz svg"

DEPEND="
	gnome-base/gnome-vfs
	gnome-base/libgtop
	gnome-extra/kiba-dock
	glitz? ( >=media-libs/glitz-0.4 )
	svg? ( gnome-base/librsvg )
"

G2CONF="${G2CONF} $(use_enable glitz) $(use_enable svg) --disable-sysinfo"

src_prepare() {
	intltoolize --force --copy || die "intltoolize failed"
	eautoreconf || die "eautoreconf failed"
}

pkg_post