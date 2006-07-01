# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE=""

inherit rpm eutils

RPM_V="4"

DESCRIPTION="Simple interface for editing the font path for the X font server"
HOMEPAGE="ftp://distro.ibiblio.org/pub/linux/distributions/fedora/linux/core/development/SRPMS/"
SRC_URI="ftp://distro.ibiblio.org/pub/linux/distributions/fedora/linux/core/development/SRPMS/${P}-${RPM_V}.src.rpm"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64 ~ppc ~sparc ~alpha ~hppa ~mips"

DEPEND="virtual/libc
	app-arch/rpm2targz
	dev-libs/popt"

RDEPEND="${DEPEND}
	sys-process/psmisc"

src_compile() {
	emake || die
}

src_install() {
	exeinto /usr/X11R6/bin
	doexe chkfontpath

	doman man/en/chkfontpath.8
}
