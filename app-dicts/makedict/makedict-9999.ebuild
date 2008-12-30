# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils cmake-utils

DESCRIPTION="XDXF based converter from any dictionary format to any"
HOMEPAGE="http://xdxf.sf.net/"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND=">=dev-libs/glib-2.6.0
		>=dev-util/cmake-2.4
		dev-libs/expat
		dev-lang/python
		sys-libs/zlib"
RDEPEND="${DEPEND}"

DOCS="AUTHORS README TODO ChangeLog"

if [[ ${PV} == 9999 ]]; then
	inherit subversion
	SRC_URI=""
	ESVN_REPO_URI="https://xdxf.svn.sourceforge.net/svnroot/xdxf/trunk"
	ESVN_PROJECT="xdxf"
	KEYWORDS=""
else
	MY_P=${PN}-${PV/_/-}-Source
	SRC_URI="mirror://sourceforge/xdxf/${MY_P}.tar.bz2"
	S=${WORKDIR}/${MY_P}
	KEYWORDS="~x86"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed 's:\(#include "repository.hpp"\):\1\n#include "generator.hpp":' \
			-i src/parser.hpp
	sed 's:\(#define _LANGS_2TO3_HPP_\):\1\n\n#include <string>:' \
			-i src/langs_2to3.hpp

#	epatch "${FILESDIR}"/${P}-codecs.patch
}
fi
