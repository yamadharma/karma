# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

DESCRIPTION="KDE - merge this to pull in all non-developer, split kde-base/* packages"
HOMEPAGE="http://www.kde.org/"
LICENSE="GPL-2"

KEYWORDS="~amd64 ~x86"
SLOT="4.1"
IUSE=""
IUSE="accessibility +admin +games +graphics +edu +l10n +multimedia +network +pim +sdk +toys +utils"

# excluded: kdebindings, kdevelop, since these are developer-only
# missing:

RDEPEND="
	>=kde-base/kdelibs-${PV}:${SLOT}
	>=kde-base/kdeartwork-meta-${PV}:${SLOT}
	>=kde-base/kdebase-meta-${PV}:${SLOT}
	>=kde-base/kate-${PV}:${SLOT}
	accessibility? ( >=kde-base/kdeaccessibility-meta-${PV}:${SLOT} )
	admin? ( >=kde-base/kdeadmin-meta-${PV}:${SLOT} )
	edu? ( >=kde-base/kdeedu-meta-${PV}:${SLOT} )
	games? ( >=kde-base/kdegames-meta-${PV}:${SLOT} )
	graphics? ( >=kde-base/kdegraphics-meta-${PV}:${SLOT} )
	l10n? ( >=kde-base/kde-l10n-${PV}:${SLOT} )
	multimedia? ( >=kde-base/kdemultimedia-meta-${PV}:${SLOT} )
	network? ( >=kde-base/kdenetwork-meta-${PV}:${SLOT} )
	pim? ( >=kde-base/kdepim-meta-${PV}:${SLOT} )
	sdk? ( >=kde-base/kdesdk-meta-${PV}:${SLOT} )
	toys? ( >=kde-base/kdetoys-meta-${PV}:${SLOT} )
	utils? ( >=kde-base/kdeutils-meta-${PV}:${SLOT} )
	"
