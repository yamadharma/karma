# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kde/kde-3.4.3.ebuild,v 1.1 2005/10/12 13:31:09 greg_g Exp $

DESCRIPTION="KDE - merge this to pull in all non-developer kde-base/* packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="3.4"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~mips ~ppc ~sparc x86"
IUSE="accessibility"

# excluded: kdebindings, kdesdk, since these are developer-only packages
RDEPEND="~kde-base/kdelibs-${PV}
	~kde-base/kdebase-${PV}
	~kde-base/kdeaddons-${PV}
	~kde-base/kdeadmin-${PV}
	~kde-base/kdeartwork-${PV}
	~kde-base/kdeedu-${PV}
	~kde-base/kdegames-${PV}
	~kde-base/kdegraphics-${PV}
	~kde-base/kdemultimedia-${PV}
	~kde-base/kdenetwork-${PV}
	~kde-base/kdepim-${PV}
	~kde-base/kdetoys-${PV}
	~kde-base/kdeutils-${PV}
	~kde-base/kdewebdev-${PV}
	accessibility? ( ~kde-base/kdeaccessibility-${PV} )"
