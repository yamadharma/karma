# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/
# This ebuild is a small modification of the official gnunet-gtk ebuild

inherit eutils qt4 flag-o-matic multilib

MY_PV=${PV/_pre/pre}
DESCRIPTION="Qt Graphical front end for GNUnet."
HOMEPAGE="http://gnunet.org/"
SRC_URI="http://gnunet.org/download/${PN}-${MY_PV}.tar.gz"

KEYWORDS="amd64 ~ppc64 x86"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="x11-libs/qt:4
	>=net-p2p/gnunet-${PV}"

S=${WORKDIR}/${PN}-${MY_PV}

src_compile() {
	append-flags -I/usr/include/qt4
	append-ldflags -L/usr/$(get_libdir)/qt4
	
	QTDIR=/usr \
	econf --with-gnunet=/usr \
	    --with-extractor \
	|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" DESTDIR="${D}" install || die "emake install failed"
	
	dodoc ChangeLog INSTALL NEWS README TODO AUTHORS
}
