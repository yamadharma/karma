# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

KMNAME=kdepim
inherit kde4overlay-meta

DESCRIPTION="Common library for KDE PIM apps"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

KMEXTRACTONLY="libkdepim/"
#KMEXTRACTONLY="kaddressbook/org.kde.KAddressbook.Core.xml
#        korganizer/korgac/org.kde.korganizer.KOrgac.xml"
KMSAVELIBS="true"

DEPEND="kde-base/libkdepim:${SLOT}"

#src_install() {
#        kde4overlay-meta_src_install
#
#}
