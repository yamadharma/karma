# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/tapiocaui/tapiocaui-0.3.0.ebuild,v 1.2 2006/05/22 00:15:21 genstef Exp $

inherit subversion mono

DESCRIPTION="C# bindings for Tapioca."
HOMEPAGE="http://tapioca-voip.sf.net"
#SRC_URI="mirror://sourceforge/tapioca-voip/${P}.tar.gz"
ESVN_REPO_URI="https://tapioca-voip.svn.sourceforge.net/svnroot/tapioca-voip/trunk/tapioca-sharp"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

RDEPEND="net-im/tapiocad
	>=dev-dotnet/gtk-sharp-2.8.2
	>=dev-dotnet/gnome-sharp-2.8.2
	>=dev-dotnet/glade-sharp-2.8.2
	>=dev-dotnet/gconf-sharp-2.8.2
	dev-dotnet/gnomevfs-sharp
	gnome-base/gnome-common
	dev-dotnet/telepathy-sharp
	gnome-base/gconf
	media-libs/farsight
	media-libs/gstreamer
	>=media-libs/gst-plugins-base-0.10.5"
#	net-im/tapioca-xmpp
DEPEND="${RDEPEND}"

src_unpack() {
	subversion_src_unpack
	cd "${S}"
	NOCONFIGURE=1 ./autogen.sh || die "./autogen.sh failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
