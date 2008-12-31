# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit games

DESCRIPTION="An open source clone of the game Colonization"
HOMEPAGE="http://commanderstalin.sourceforge.net/"
SRC_URI="mirror://sourceforge/commanderstalin/${P}-src.tar.gz"

KEYWORDS="x86 amd64"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

S=${WORKDIR}/${P}-src

RDEPEND="dev-lang/lua
	x11-libs/libX11
	virtual/opengl"

DEPEND="${RDEPEND}
	dev-util/scons"

src_prepare() {
	sed -i -e "s:.Copy():.Clone():g" \
		SConstruct

}


src_compile() {
#	scons PREFIX=/usr configure || die
	scons PREFIX=/usr || die
}

src_install() {
#	scons DESTDIR="${D}" install || die "emake install failed"

	dodir /opt/${PN}
	for i in campaigns doc graphics intro languages maps music scripts sounds units video
	do
		cp -R ${i} ${D}/opt/${PN}
	done
	insinto /opt/${PN}
	newins boswars ${PN}

	dodoc CHANGELOG COPYRIGHT.txt LICENSE.txt README.txt
}
