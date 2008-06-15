# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

inherit eutils

DESCRIPTION="Allows you to mount directories shared over GNUnet as Linux file-systems"
HOMEPAGE="http://www.gnunet.org"
SRC_URI="http://gnunet.org/download/${P}.tar.bz2"
IUSE=""
LICENSE="GPL"
SLOT="0"
KEYWORDS="x86 amd64"

DEPEND=">=sys-libs/glibc-2.3.3
	>=sys-fs/fuse-2.6.1
	>=net-p2p/gnunet-${PV}"

RDEPEND=">=sys-fs/fuse-2.6.1"

S=${WORKDIR}/${P}

src_compile() {
	./configure --prefix=/usr || die "Configure failed"
	emake || die "Make failed"
}

src_install() {
	make DESTDIR=${D} install || die "Install failed"
}
