# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/dvdbackup/dvdbackup-0.1.1-r2.ebuild,v 1.9 2007/11/27 12:38:23 zzam Exp $

EAPI="2"

inherit toolchain-funcs eutils

DESCRIPTION="Backup content from DVD to hard disk"
HOMEPAGE="http://sourceforge.net/projects/dvdbackup/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND="media-libs/libdvdread
	virtual/libintl"
RDEPEND="${DEPEND}"

src_compile() {
	econf --docdir="/usr/share/doc/${PF}" || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog
}
