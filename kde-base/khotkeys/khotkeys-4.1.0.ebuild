# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

KMNAME=kdebase-workspace
inherit kde4overlay-meta

DESCRIPTION="KDE: hotkey daemon"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND=">=kde-base/libkworkspace-${PV}:${SLOT}
	x11-libs/libXtst"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="libs/kworkspace/"
