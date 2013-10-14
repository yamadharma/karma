# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/dnspython/dnspython-1.8.0.ebuild,v 1.8 2010/08/16 16:50:27 grobian Exp $

EAPI="4"

inherit git-2
EGIT_REPO_URI="http://github.com/ashipunov/${PN}.git"

DESCRIPTION="Shell utility to manipulate pages of DjVu file"
HOMEPAGE="http://github.com/ashipunov/${PN}"
# SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-solaris"
IUSE=""

DEPEND=""
RDEPEND="app-text/djvu
	app-text/img2djvu"

src_install() {
	dobin ${PN}
	dodoc NEWS README TODO
}