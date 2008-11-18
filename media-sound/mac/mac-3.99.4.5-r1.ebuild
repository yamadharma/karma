# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator

MY_P="${PN}-$(get_version_component_range 1-2)"
MY_P="${MY_P}-u$(get_version_component_range 3)"
MY_P="${MY_P}-b$(get_version_component_range 4)"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Unix port of Monkey's Audio codec"
HOMEPAGE="http://www.monkeysaudio.com/"
SRC_URI="http://www.genoetigt.de/ape//${MY_P}.tar.gz"

# License status is unclear, see discussion in
# https://bugs.gentoo.org/94477 and 52882
LICENSE="monkeysaudio"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="dev-lang/yasm"

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodoc AUTHORS INSTALL NEWS README TODO
	dohtml ${S}/src/Readme.htm
}
