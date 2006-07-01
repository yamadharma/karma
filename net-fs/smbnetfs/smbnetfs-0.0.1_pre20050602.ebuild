# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ECVS_CVS_COMMAND="cvs -q"
ECVS_SERVER="cvs.airm.net:/cvsroot"
ECVS_USER="anonymous"
ECVS_MODULE="smbnetfs"
ECVS_TOP_DIR="${DISTDIR}/cvs-src/cvs.airm.net"
inherit cvs

S=${WORKDIR}/${ECVS_MODULE}

DESCRIPTION="SMBNetFS is a Linux filesystem that allow you to use samba/microsoft network in the same manner as the network neighborhood in Microsoft Windows."
HOMEPAGE="http://smbnetfs.airm.net/"

KEYWORDS="x86 amd64 ~ppc"
LICENSE="GPL-2"
SLOT="0"

DEPEND=">=sys-fs/fuse-2.3_rc1
	net-fs/samba"
RDEPEND="${DEPEND}"

src_install ()
{
	newbin test smbnetfs
}