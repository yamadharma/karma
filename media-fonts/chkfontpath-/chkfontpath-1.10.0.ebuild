# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit rpm patch

IUSE="${IUSE}"

RELEASE=2
MY_PV=${PV}-${RELEASE}
MY_P=${PN}-${MY_PV}

S=${WORKDIR}/${P}
DESCRIPTION="Simple interface for editing the font path for the X font server."
HOMEPAGE="mirror://fedora/development/SRPMS"
SRC_URI="mirror://fedora/development/SRPMS/${MY_P}.src.rpm"

LICENSE="GPL"
SLOT="0"
KEYWORDS="x86 sparc sparc64 ppc"

DEPEND="app-arch/rpm2targz
	app-arch/rpm
	dev-libs/popt"

RDEPEND="${DEPEND}
	sys-process/psmisc"

src_unpack ()
{
    rpm_src_unpack

    cd ${S}
    patch_apply_patch
}

src_compile () 
{
    emake || die
}

src_install () 
{
    cd ${S}
    dosbin chkfontpath
    doman man/en/chkfontpath.8
}

