# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

inherit cmake-utils # vcs-snapshot

P_EXTRA=-poppler-0.81.0

DESCRIPTION="A PDF to HTML converter"
HOMEPAGE="https://github.com/pdf2htmlEX/pdf2htmlEX
    http://coolwanglu.github.com/pdf2htmlEX/"
SRC_URI="https://github.com/pdf2htmlEX/pdf2htmlEX/archive/v${PV}${P_EXTRA}.tar.gz"

LICENSE="GPL-2 GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="+svg"

RDEPEND=">=app-text/poppler-0.32[cjk,png,jpeg2k]
	>=media-gfx/fontforge-20150228
	svg? (
	  >=x11-libs/cairo-1.10[svg]
	  media-libs/freetype
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${P}${P_EXTRA}

#src_prepare(){
#	epatch ${FILESDIR}/pdf2htmlEX-0.12-fix-poppler.patch
#	epatch_user
#	mycmakeargs="
#	  $(cmake-utils_use_enable svg SVG)
#	"
#	vcs-snapshot_src_parpare
#	cmake-utils_src_parpare
#}
