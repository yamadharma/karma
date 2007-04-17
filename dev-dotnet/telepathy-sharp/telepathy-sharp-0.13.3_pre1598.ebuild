# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/tapiocaui/tapiocaui-0.3.0.ebuild,v 1.2 2006/05/22 00:15:21 genstef Exp $

inherit subversion mono

DESCRIPTION="Telepathy C# bindings"
HOMEPAGE="http://telepathy.freedesktop.org/wiki/TelepathySharp"
#SRC_URI="mirror://sourceforge/tapioca-voip/${P}.tar.gz"

#ESVN_OPTIONS="-r${PV/*_pre}"
ESVN_STORE_DIR="${PORTAGE_ACTUAL_DISTDIR-${DISTDIR}}/svn-src/sourceforge.net/tapioca-voip"
ESVN_REPO_URI="https://svn.sourceforge.net/svnroot/tapioca-voip/trunk/telepathy-sharp"

LICENSE="LGPL-2"
SLOT="0"

KEYWORDS="x86 amd64"
IUSE=""

# gtk-sharp gnome-sharp gnomevfs-sharp glade-sharp gconf-sharp
DEPEND="net-libs/libtelepathy"
RDEPEND=${DEPEND}

src_unpack() {
	subversion_src_unpack

	# Dirty hack
	sed -i -e "s:public static class ChannelType:public class ChannelType:" ${S}/telepathy/IConnection.cs

	cd ${S}	
	NOCONFIGURE=1 ./autogen.sh
}

src_install() {
	emake DESTDIR=${D} install || die "emake install failed"
}
