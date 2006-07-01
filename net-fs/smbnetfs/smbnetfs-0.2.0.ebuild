# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P=${P/_/-}
S=${WORKDIR}/${MY_P}

DESCRIPTION="A Linux filesystem that allow you to use samba/microsoft network in the same manner as the network neighborhood in Microsoft Windows."
HOMEPAGE="http://smbnetfs.airm.net/"
SRC_URI="http://smbnetfs.airm.net/sources/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

RDEPEND=">=sys-fs/fuse-2.3
	<net-fs/samba-3.13*"

DEPEND="${RDEPEND}"

src_compile () 
{
	econf || die "configure failed"
	
	emake || die "make failed"
}

src_install () 
{
	einstall || die "install failed"

	cd ${S}
	rm -rf ${D}/usr/share/doc
	dodoc README ChangeLog
	dodoc doc/*
	
	dodir /etc/profile.d
	exeinto /etc/profile.d
	doexe ${FILESDIR}/smbnetfs.sh
	doexe ${FILESDIR}/smbnetfs.csh
}

pkg_postinst ()
{
	einfo "Sample config file is /etc/.smbnetfs"
        einfo "Copy it into your home directory and change file permissions to 600"
}