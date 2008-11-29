# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils gnome2 subversion

ESVN_REPO_URI="https://kibadock.svn.sourceforge.net/svnroot/kibadock/trunk/${PN}/"

S="${WORKDIR}/${PN}"

DESCRIPTION="Simple, but fun, physics engine prototype."
HOMEPAGE="http://kiba-dock.org"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=">=dev-libs/glib-2.8"

src_unpack () {
	subversion_src_unpack
	cd "${S}"

	sed -i -e "/AC_SUBST(/ s/\"\$AKAMARU_REQUIRES\"/AKAMARU_REQUIRES/" configure.in \
		|| die "AKAMARU_REQUIRES sed failed"
	eautoreconf
}

pkg_postinst() {
	gnome2_pkg_postinst
	echo
	ewarn "DO NOT report bugs to Gentoo's bugzilla"
	einfo "Please report all bugs to #gentoo-desktop-effects"
	einfo "Thank you on behalf of the Gentoo Desktop-Effects team"
}
