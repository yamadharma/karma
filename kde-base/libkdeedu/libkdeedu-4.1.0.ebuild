# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

KMNAME=kdeedu
inherit kde4overlay-meta

# get weird "Exception: Other". broken.
RESTRICT="test"

DESCRIPTION="common library for kde educational apps."
KEYWORDS="~amd64 ~x86"
IUSE="debug"

src_install() {
	kde4overlay-meta_src_install
	"rm ${D}/usr/kde/4.1/share/apps/cmake/modules/FindMarbleWidget.cmake"
}
