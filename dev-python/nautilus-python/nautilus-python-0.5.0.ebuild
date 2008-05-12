# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome.org

DESCRIPTION="Python bindings for the Nautilus file manager."
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=">=dev-python/pygtk-2.8
	>=dev-python/gnome-python-2.12
	>=gnome-base/nautilus-2.6
	>=gnome-base/eel-2.6"
RDEPEND="${DEPEND}"

src_compile() {
	econf  || die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	mv "${D}"/usr/share/doc/{${PN},${PF}}
}
