# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="GTK+ GUI for netcat"
HOMEPAGE="http://lxde.sourceforge.net/"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

# Python 2.4+: ConfigParser.SafeConfigParser
# PyGTK 2.10+: gtk.Assistant
RDEPEND=">=dev-lang/python-2.4
	>=dev-python/pygtk-2.10"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-lang/perl-5.6
	dev-perl/XML-Parser
	>=dev-util/intltool-0.21
	|| ( net-analyzer/netcat net-analyzer/netcat-openbsd )"

src_prepare() {
	# net-analyzer/netcat needs -q0 instead of --close
	sed -i -e 's:nc\(.*\) --close:nc\1 -q0:g' src/gtknetcat.py || die "sed failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README
}
