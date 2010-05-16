# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit etoile-svn

S1=${S}/Services/User/Jabber

DESCRIPTION="Etoilé instant messenger for jabber"
HOMEPAGE="http://www.etoile-project.org"


LICENSE="BSD"
KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"
IUSE=""

DEPEND=">=gnustep-base/gnustep-gui-0.16.0
	>=gnustep-libs/etoile-serialize-${PV}
	>=gnustep-libs/xmppkit-${PV}"
RDEPEND="${DEPEND}"
