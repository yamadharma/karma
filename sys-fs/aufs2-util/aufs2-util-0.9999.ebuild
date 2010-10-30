# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils git toolchain-funcs

EGIT_REPO_URI="http://git.c3sl.ufpr.br/pub/scm/aufs/aufs2-util.git"

DESCRIPTION="Userspace utilities for aufs2"
HOMEPAGE="http://aufs.sourceforge.net/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

RDEPEND="!sys-fs/aufs-utils"

src_compile() {
#	emake KDIR=/usr/src/linux || die
	emake CC=$(tc-getCC) AR=$(tc-getAR) KDIR=/usr/src/linux C_INCLUDE_PATH="${S}"/include CFLAGS="-I/usr/src/linux/include -I./libau" || die
}

src_install() {
	dodir /sbin
	dodir /usr/bin
	dodir /etc/default/aufs
	make install DESTDIR=${D} || die

	dodoc README
}
