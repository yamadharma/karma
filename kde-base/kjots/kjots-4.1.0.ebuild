# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

KMNAME=kdepim
inherit kde4overlay-meta

DESCRIPTION="Kjots - KDE note taking utility"
KEYWORDS="~amd64 ~x86"
IUSE="debug htmlhandbook"

KMEXTRACTONLY="libkdepim"

src_compile() {
	MAKEOPTS="${MAKEOPTS} -j1"  # parallel builds seem to fail
				# with generating dbus interfaces

	kde4overlay-meta_src_compile
}
