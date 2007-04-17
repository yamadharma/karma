# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/tapiocaui/tapiocaui-0.3.0.ebuild,v 1.2 2006/05/22 00:15:21 genstef Exp $

inherit subversion mono

DESCRIPTION="Tapioca UI"
HOMEPAGE="http://tapioca-voip.sf.net"
#SRC_URI="mirror://sourceforge/tapioca-voip/${P}.tar.gz"
ESVN_REPO_URI="https://svn.sourceforge.net/svnroot/landell/trunk/landell"
LICENSE="LGPL-2"
SLOT="0"

KEYWORDS="x86 amd64"
IUSE=""

# gtk-sharp gnome-sharp gnomevfs-sharp glade-sharp gconf-sharp
RDEPEND="net-im/tapiocad
	gnome-base/gconf
	media-libs/farsight
	media-libs/gstreamer
	>=media-libs/gst-plugins-base-0.10.5
	>=dev-dotnet/tapioca-sharp-0.13.2"
#	net-im/tapioca-xmpp
#	dev-libs/libxml2

src_unpack() {
	subversion_src_unpack
	cd ${S}
	NOCONFIGURE=1 ./autogen.sh
}

src_compile() {
	econf || die "econf failed"
	emake
	emake
}

src_install() {
	emake DESTDIR=${D} install
	emake DESTDIR=${D} install
	#|| die "make install failed"
}

pkg_postinst() {
	einfo "If you are using kde you need to run"
	echo 'eval `dbus-launch --sh-syntax --exit-with-session`'
	einfo "in the same environment where you start tapiocaui later"
}
