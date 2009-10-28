# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P=${P/_/-}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Get access to samba shares from your filesystem easily."
HOMEPAGE="http://sourceforge.net/projects/smbnetfs"
SRC_URI="mirror://sourceforge/smbnetfs/${P}.tar.bz2"


LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+autostart"

RDEPEND=">=sys-fs/fuse-2.3
		>=net-fs/samba-3.0.21"
# >=net-fs/samba-3.2.0 is recommended but
# >=net-fs/samba-3.0.21 still works fine

DEPEND="${RDEPEND}"

src_install () 
{
	einstall || die "install failed"

	cd ${S}
	rm -rf ${D}/usr/share/doc
	dodoc AUTHORS README ChangeLog TODO
	dodoc doc/*
	docinto conf
	dodoc conf/*

	dobin ${FILESDIR}/config-smbnetfs
	dosed -i -e "s:@PF@:${PF}:g" /usr/bin/config-smbnetfs

	if use autostart; then
		dodir /etc/profile.d
		insinto /etc/profile.d
		doins ${FILESDIR}/smbnetfs.sh
	fi
}

pkg_postinst ()
{
	elog "Run config-smbnetfs as unprivileged user to set up"
	elog "the configuration files in your home directory."
}
