# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/mhddfs-0.1.16.ebuild,v 1.0 2008/11/19 23:35:38 mrakobes Exp $

inherit eutils

MY_P=${PN}_${PV}

DESCRIPTION="Multi hardsdrive filesystem"
HOMEPAGE="http://mhddfs.uvw.ru/"
SRC_URI="http://mhddfs.uvw.ru/downloads/${MY_P}.tar.gz"

RESTRICT="mirror"

LICENSE="GPL-3 or later"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="suid"

DEPEND=">=sys-fs/fuse-2.7.0"

src_install(){
    dobin ${PN}
    doman ${PN}.1
    dodoc ChangeLog README README.ru.UTF-8
    use suid && fperms u+s /usr/bin/${PN}
}

pkg_postinst() {
    if use suid; then
    ewarn
    ewarn "You have chosen to install ${PN} with the binary setuid root. This"
    ewarn "means that if there any undetected vulnerabilities in the binary,"
    ewarn "then local users may be able to gain root access on your machine."
    ewarn
    fi
}