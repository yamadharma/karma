# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="Medical Image Conversion Utility with a GTK interface"
HOMEPAGE="http://xmedcon.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

# The libs are LGPL-2.1
# The user interface GPL-2
LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="png gtk +dicom"
RESTRICT=mirror

RDEPEND="
png? ( >=media-libs/libpng-1.2.1 )
gtk? ( >=x11-libs/gtk+-2.1 )
"

src_compile() {

	econf \
		$(use_enable png) \
		$(use_enable dicom) \
		$(use_enable gtk gui) \
		|| die "econf failed"
	emake || die "emake failed"

}

src_install() {

	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS NEWS README REMARKS
#	doicon "${D}"/etc/xmedcon.png
#	rm "${D}"/etc/xmedcon.ico
#	rm "${D}"/etc/xmedcon.png
#	rm "${D}"/etc/xmedconrc.win32
}

