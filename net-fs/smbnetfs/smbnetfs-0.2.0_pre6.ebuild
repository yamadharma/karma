# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_PV=0.2.0-pre6
DESCRIPTION="A Linux filesystem that allow you to use samba/microsoft network in the same manner as the network neighborhood in Microsoft Windows."
HOMEPAGE="http://smbnetfs.airm.net/"
SRC_URI="http://smbnetfs.airm.net/sources/${PN}-${MY_PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=sys-fs/fuse-2.3
	net-fs/samba"

DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}

src_compile() {
	emake || die "make failed"
}

src_install() {
	exeinto /usr/local/bin
	insinto /etc
	doexe smbnetfs || die "doexe failed"
	doins ${S}/../.smbnetfs || die "doins failed"
}

pkg_postinst(){
	einfo "Sample config file is /etc/.smbnetfs"
        einfo "Copy it into your home directory and change file permissions to 600"
}