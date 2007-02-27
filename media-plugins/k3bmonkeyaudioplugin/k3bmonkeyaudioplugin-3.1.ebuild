# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/k3b/k3b-1.0_rc6.ebuild,v 1.1 2007/02/11 09:32:48 deathwing00 Exp $

inherit kde eutils

MY_P=${P/_/}
S="${WORKDIR}/${MY_P}"

DESCRIPTION="K3b Monkey's Audio Encoder and Decoder plugin"
HOMEPAGE="http://www.k3b.org/"
SRC_URI="mirror://sourceforge/k3b/${MY_P}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="( || ( kde-base/kdesu kde-base/kdebase ) )
	( >=app-cdr/k3b-0.12.7 )"

RDEPEND="${DEPEND}"

need-kde 3.2


