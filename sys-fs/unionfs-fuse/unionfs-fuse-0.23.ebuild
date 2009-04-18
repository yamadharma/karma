# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

EAPI=2

DESCRIPTION="A FUSE-based implementation of unionfs"
HOMEPAGE="http://podgorny.cz/unionfs-fuse"
SRC_URI="http://podgorny.cz/unionfs-fuse/releases/${P}.tar.bz2"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
DEPEND="sys-fs/fuse"
RDEPEND="sys-fs/fuse"


src_install() {
		dosbin src/unionfs
		doman man/unionfs-fuse.8
		dodoc NEWS CREDITS LICENSE
}
