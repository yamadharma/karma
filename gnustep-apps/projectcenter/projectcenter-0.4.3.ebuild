# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/projectcenter/projectcenter-0.4.2.ebuild,v 1.1 2005/03/17 21:08:48 fafhrd Exp $

inherit gnustep

S=${WORKDIR}/${P/projectc/ProjectC}

DESCRIPTION="An IDE for GNUstep."
HOMEPAGE="http://www.gnustep.org/experience/ProjectCenter.html"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/dev-apps/${P/projectc/ProjectC}.tar.gz"

KEYWORDS="x86 amd64 ~ppc"
LICENSE="GPL-2"
SLOT="0"

DEPEND="${GS_DEPEND}"
RDEPEND="${GS_RDEPEND}
	>=sys-devel/gdb-6.0"

egnustep_install_domain "System"

src_unpack () 
{
	unpack ${A}
	cd ${S}
	egnustep_env
	if [ -z "${GNUSTEP_FLATTENED}" ]; then
		epatch ${FILESDIR}/pc-non-flattened.patch
	fi
}

