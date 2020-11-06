# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/dnspython/dnspython-1.8.0.ebuild,v 1.8 2010/08/16 16:50:27 grobian Exp $

EAPI="7"

inherit git-r3
EGIT_REPO_URI="http://github.com/ashipunov/${PN}.git"

DESCRIPTION="Single-pass DjVu encoder based on DjVu Libre, minidjvu and ImageMagick"
HOMEPAGE="http://github.com/ashipunov/img2djvu"
# SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-solaris"
IUSE=""

DEPEND=""
RDEPEND="app-text/djvu
	app-text/minidjvu
	media-gfx/imagemagick
	"
#	app-text/ocrodjvu

src_install() {
	dobin img2djvu
	dodoc NEWS README TODO
}