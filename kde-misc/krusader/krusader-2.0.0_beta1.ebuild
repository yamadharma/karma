# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P="${P/_/-}"

EAPI="1"
NEED_KDE="4.1"
inherit kde4overlay-base

PREFIX="${KDEDIR}"

DESCRIPTION="An advanced twin-panel (commander-style) file-manager for KDE with many extras."
HOMEPAGE="http://krusader.org/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
KEYWORDS="amd64 x86"
SLOT="0"
IUSE=""

DEPEND="sys-devel/gettext"
RDEPEND="${DEPEND}"

LANGS="ca cs da de el en_GB fr ga gl ja ko nds nl pt pt_BR ro ru sv tr uk"
for X in ${LANGS}; do
	IUSE="${IUSE} linguas_${X}"
done


src_unpack() {
	unpack ${A}
	cd "${S}/.."
	mv "$MY_P" "$P"
}

src_compile() {
	comment_all_add_subdirectory po/ || die "sed to remove all linguas failed."

	local X
	for X in ${LANGS}; do
		if use linguas_${X}; then
			sed -i -e "/add_subdirectory(\s*${X}\s*)\s*$/ s/^#DONOTCOMPILE //" \
			po/CMakeLists.txt || die "Sed to uncomment linguas_${lang} failed."
		fi
	done

	kde4overlay-base_src_compile
}
