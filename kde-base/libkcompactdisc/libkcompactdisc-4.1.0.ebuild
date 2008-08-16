# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

KMNAME=kdemultimedia
inherit kde4overlay-meta

DESCRIPTION="KDE library for playing & ripping CDs"
KEYWORDS="~amd64 ~x86"
IUSE="alsa debug htmlhandbook"

DEPEND="=media-sound/phonon-4.2*"

src_compile() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with alsa Alsa)"
	kde4overlay-meta_src_compile
}
