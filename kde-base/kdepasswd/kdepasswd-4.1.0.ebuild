# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

KMNAME=kdebase
KMMODULE=apps/${PN}

inherit kde4overlay-meta

DESCRIPTION="KDE GUI for passwd"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND=">=kde-base/libkonq-${PV}:${SLOT}"
RDEPEND="${DEPEND}
	>=kde-base/kdesu-${PV}:${SLOT}"

KMLOADLIBS="libkonq"
