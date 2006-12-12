# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools

DESCRIPTION="OGMRip CLI client"
HOMEPAGE="http://ogmrip.sourceforge.net/"
SRC_URI="mirror://sourceforge/ogmrip/${P}.tar.gz"
	
LICENSE="LGPL-2.1"

SLOT="0"
IUSE="aac debug doc gtk hal matroska spell srt theora"
KEYWORDS="amd64 ~ppc ~ppc64 x86"

RDEPEND=">=dev-libs/glib-2.6
	>=media-video/ogmrip-0.10.0"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.29
	>=dev-util/pkgconfig-0.12.0"

DOCS="AUTHORS ChangeLog README NEWS TODO"

src_install () {
	einstall || die
	dodoc ChangeLog INSTALL NEWS README TODO shrip.conf AUTHORS
}
