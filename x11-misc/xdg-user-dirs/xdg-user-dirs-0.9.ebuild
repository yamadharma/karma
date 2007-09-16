# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="xdg-user-dirs is a tool to help manage 'well known' user directories like the desktop folder and the music folder"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/xdg-user-dirs"
SRC_URI="http://user-dirs.freedesktop.org/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README TODO
}

