# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/rkward/rkward-0.4.7.ebuild,v 1.3 2007/04/27 10:01:52 bicatali Exp $

ARTS_REQUIRED="never"

inherit kde

DESCRIPTION="An IDE/GUI for the R-project"
HOMEPAGE="http://rkward.sourceforge.net/"
SRC_URI="mirror://sourceforge/rkward/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-lang/R"
RDEPEND="${DEPEND} dev-lang/php"

need-kde 3

src_install() {
	kde_src_install
	# already provided by R
	rm -f "${D}"/usr/$(get_libdir)/R/library/R.css
	# already provided by kdelibs
	rm -f "${D}"/share/apps/katepart/syntax/r.xml
}
