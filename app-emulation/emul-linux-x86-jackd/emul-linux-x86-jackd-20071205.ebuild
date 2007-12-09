# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils emul-linux-x86

DESCRIPTION="emul package for jack audio connection kit"
HOMEPAGE="http://gimpel.ath.cx/~tom/distfiles/"
SRC_URI="http://gimpel.ath.cx/~tom/distfiles/${P}.tbz2"

RESTRICT="nomirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND=">=app-emulation/emul-linux-x86-baselibs-20071114
	>=app-emulation/emul-linux-x86-medialibs-20071114
	media-sound/jack-audio-connection-kit"


pkg_setup() {
	echo
	ewarn "This ebuild has been compiled on an AMD processor with"
	ewarn "CFLAGS=\"-march=k8 -O2 -pipe -fomit-frame-pointer\""
	ewarn "and will most likely blow away your roof, kill your cat and"
	ewarn "make your wife run away with some other dude!"
	echo
	ewarn "Also it will overwrite libjack.so from emul-linux-x86-soundlibs,"
	ewarn "so use FEATURES=\"-collision-protect\"."
	sleep 10
	echo

	if ! built_with_use media-sound/jack-audio-connection-kit netjack; then
		eerror "You need to compile jack-audio-connection-kit with"
		eerror "USE=\"netjack\" enabled"
		die
	fi
}

src_unpack() {
	_ALLOWED="${S}/usr/bin/jackd32|${S}/usr/bin/jacknet_client32"
	ALLOWED="(${_ALLOWED})"

	emul-linux-x86_src_unpack
}

pkg_postinst() {
	echo
	ewarn "This ebuild has been compiled on an AMD processor with"
	ewarn "CFLAGS=\"-march=k8 -O2 -pipe -fomit-frame-pointer\""
	ewarn "and will most likely blow away your roof, kill your cat and"
	ewarn "make your wife run away with some other dude!"
	echo

	einfo "To run a 32bit and 64bit instance of jack in parallel:"
	echo
	einfo "In Terminal window A (64bit side):"
	einfo "$ jackd -dalsa -R &"
	einfo "$ jacknet_client -p localhost &"
	echo
	einfo "In Terminal window B (32bit side):"
	einfo "$ export JACK_DEFAULT_SERVER=\"jackd32\""
	einfo "$ jackd32 -d net &"
	echo
	einfo "You HAVE TO export JACK_DEFAULT_SERVER for every 32bit jack"
	einfo "application you want to start, otherwhise they try to connect"
	einfo "to the default (64bit) instance!"
}
