# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde versionator

DESCRIPTION="KDE front-end for XNeur keybord layout switcher"
HOMEPAGE="http://www.xneur.ru/"
if [[ "${PV}" =~ (_p)([0-9]+) ]] ; then
	inherit subversion
	SRC_URI=""
	MTSLPT_REV=${BASH_REMATCH[2]}
	ESVN_REPO_URI="svn://xneur.ru:3690/xneur/${PN}/@${MTSLPT_REV}"
else
	SRC_URI="http://dists.xneur.ru/release-${PV}/tgz/${P}.tar.bz2"
fi

LICENSE="GPL-2"
KEYWORDS="x86 amd64"
IUSE=""

RDEPEND=">=x11-apps/xneur-$(get_version_component_range 1-2)"

need-kde 3.4

src_install() {
	kde_src_install all
	doman kxneur.1
}
