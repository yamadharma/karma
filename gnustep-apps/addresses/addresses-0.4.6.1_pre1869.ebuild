# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit etoile-svn

S1=${S}/Services/User/AddressManager

DESCRIPTION="Addresses is a Apple Addressbook work alike (standalone and for GNUMail)"
HOMEPAGE="http://www.etoile-project.org"
#SRC_URI=""
LICENSE="GPL-2"
KEYWORDS="~ppc x86 amd64"
SLOT="0"

IUSE=""
DEPEND="${GS_DEPEND}
	gnustep-libs/addresseskit"
RDEPEND="${GS_RDEPEND}
	gnustep-libs/addresseskit"
