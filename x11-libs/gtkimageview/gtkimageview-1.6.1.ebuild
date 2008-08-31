# Copyright 1999-2008 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="GtkImageView is a simple image viewer widget for GTK. Similar to the image viewer panes in gThumb or Eye of Gnome. It makes writing image viewing and editing applications easy."
HOMEPAGE="http://trac.bjourne.webfactional.com/"
SRC_URI="http://trac.bjourne.webfactional.com/attachment/wiki/WikiStart/${P}.tar.gz?format=raw"
LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""
DEPEND=">=x11-libs/gtk+-2.6.0"
#S=${WORKDIR}/${P}

src_unpack() {
	mv "${DISTDIR}/${P}.tar.gz?format=raw" "${DISTDIR}/${P}.tar.gz"
	unpack ${P}.tar.gz
}

src_compile() {
	econf || die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodoc COPYING README
}
