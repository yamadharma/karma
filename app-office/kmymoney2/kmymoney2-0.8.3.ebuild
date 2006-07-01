# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/kmymoney2/kmymoney2-0.8.3.ebuild,v 1.1 2006/02/23 17:08:56 carlo Exp $

inherit kde

DESCRIPTION="Personal Finances Manager for KDE."
HOMEPAGE="http://kmymoney2.sourceforge.net"
SRC_URI="mirror://sourceforge/kmymoney2/${P}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE="crypt ofx"

DEPEND="dev-libs/libxml2
	ofx? ( >=dev-libs/libofx-0.7 )"

RDEPEND="${DEPEND}
	crypt? ( app-crypt/gnupg )"

need-kde 3.2

# TODO: support maketest
# (needs cppunit in DEPEND)

src_compile() {
	local myconf="$(use_enable ofx ofxplugin)
	              --disable-kbanking
	              --disable-cppunit"

	kde_src_compile
}
