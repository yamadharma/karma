# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"
XDPVER=4

inherit x-modular

EGIT_REPO_URI="git://anongit.freedesktop.org/git/nouveau/xf86-video-nouveau"

DESCRIPTION="nouveau X.Org driver for nvidia cards"

KEYWORDS="x86 amd64"

RDEPEND=">=x11-base/xorg-server-1.3
	=x11-libs/libdrm-9999"
DEPEND="${RDEPEND}
	x11-proto/fontsproto
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/videoproto
	x11-proto/xextproto
	x11-proto/xproto
	x11-proto/xf86driproto
	x11-proto/glproto
	=x11-libs/libdrm-9999"

src_unpack() {
	x-modular_src_unpack

	# Re-run autoreconf with the proper GIT_DIR to get revision string.
	export GIT_DIR="${EGIT_STORE_DIR}/${GIT_DIR}"
	x-modular_reconf_source
}

