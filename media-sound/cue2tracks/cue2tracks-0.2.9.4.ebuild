# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Bash script for split audio CD image files with cue sheet to tracks and write tags."
HOMEPAGE="http://cyberdungeon.org.ru/~killy/projects/${PN}/"
SRC_URI="http://freshgen.googlecode.com/files/cue2tracks-0.2.9.4.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="flake mac tta shorten wavpack mp3 vorbis"

DEPEND="flake? ( media-sound/flake )
	mac? ( media-sound/mac media-sound/apetag )
	tta? ( media-sound/ttaenc )
	shorten? ( media-sound/shorten )
	wavpack? ( media-sound/wavpack media-sound/apetag )
	mp3? ( media-sound/lame media-sound/id3v2 )
	vorbis? ( media-sound/vorbis-tools )"
RDEPEND=">=media-sound/shntool-3.0.0
	app-shells/bash
	media-libs/flac
	app-cdr/cuetools"

pkg_setup()
{
	if has_version '=media-sound/ttaenc-3.3*' && ! built_with_use media-sound/ttaenc shntool && use tta ; then
		echo ""
		einfo "Installed media-sound/ttaenc not compiled with shntool support"
		einfo "To recompile it with shntool you need apply the patch"
		einfo "http://cyberdungeon.org.ru/~killy/files/projects/cue2tracks/ttaenc-3.3-shntool.patch"
		echo ""
		einfo "add the line at end of section src_unpack()"
		einfo " epatch \${FILESDIR}/ttaenc-3.3-shntool.patch"
		echo ""
		einfo "and reemerge modified media-sound/ttaenc"
		echo ""
		einfo "Or download ebuild with patchset from overlay:"
		einfo "ftp://cyberdungeon.org.ru/Distributions/Linux/gentoo/overlays/killy-overlay/media-sound/ttaenc/"
		epause 5
	fi
}

src_install() {
	dobin "${PN}" || die
	dodoc AUTHORS INSTALL ChangeLog README TODO
}

pkg_postinst() {
	echo ""
	einfo 'To get help about usage run "$ cue2tracks -h"'
	echo ""
}

