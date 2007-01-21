# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/sim/sim-0.9.9999.ebuild,v 1.7 2004/06/24 23:00:02 agriffis


inherit eutils subversion kde-functions

LICENSE="GPL-2"
DESCRIPTION="An ICQ v8 Client. Supports File Transfer, Chat, Server-Side Contactlist, ..."
HOMEPAGE="http://sim-im.berlios.de"
KEYWORDS="~x86 ~ppc ~amd64"
SLOT="0"
IUSE="ssl kde debug qt4 arts"
MAKEOPTS="-j1"

RDEPEND="ssl? ( dev-libs/openssl )
     kde? ( || ( kde-base/kdebase-startkde kde-base/kdebase ) )
     !kde? ( x11-libs/qt )
     app-text/sablotron
     sys-devel/flex
     >=sys-devel/automake-1.7
     >=sys-devel/autoconf-2.5
     dev-libs/libxslt
     qt4? ( >=x11-libs/qt-4.0 )
     arts? ( kde-base/arts )"

pkg_setup() {
   if use qt4; then
        ESVN_REPO_URI="svn://svn.berlios.de/sim-im/trunk/sim-qt4"
        einfo "Qt4 version"
   else
        ESVN_REPO_URI="svn://svn.berlios.de/sim-im/trunk/sim"
        einfo "Qt3 version"
   fi
}

src_compile() {
   export WANT_AUTOCONF=2.5
   export WANT_AUTOMAKE=1.7

   set-qtdir 3
   set-kdedir 3
   addwrite "${QTDIR}/etc/settings"

   make -f admin/Makefile.common

   econf\
        `use_with ssl` \
        `use_with arts` \
        `use_enable kde` \
        `use_enable debug` \
        || die "Configuration failed!"

   make clean || die
   emake || die
}

src_install() {
     make DESTDIR=${D} install || die
     dodoc TODO README ChangeLog COPYING AUTHORS
}
