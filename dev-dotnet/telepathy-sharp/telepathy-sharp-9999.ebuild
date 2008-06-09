# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/tapiocaui/tapiocaui-0.3.0.ebuild,v 1.2 2006/05/22 00:15:21 genstef Exp $

inherit subversion mono

DESCRIPTION="Telepathy C# bindings"
HOMEPAGE="http://telepathy.freedesktop.org/wiki/TelepathySharp"
#SRC_URI="mirror://sourceforge/tapioca-voip/${P}.tar.gz"
ESVN_REPO_URI="https://tapioca-voip.svn.sourceforge.net/svnroot/tapioca-voip/trunk/telepathy-sharp"

LICENSE="MIT"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="dev-lang/mono
	net-libs/libtelepathy
	dev-dotnet/ndesk-dbus
	gnome-base/gnome-common"
RDEPEND=${DEPEND}

src_unpack() {
	subversion_src_unpack
	cd "${S}"
	NOCONFIGURE=1 ./autogen.sh || die "./autogen.sh failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README AUTHORS COPYING
}
