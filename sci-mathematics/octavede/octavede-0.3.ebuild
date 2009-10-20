# Copyright 1999-2009 Tiziano Müller
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="Development environment for Octave."
HOMEPAGE="http://octavede.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="opengl webkit"

RDEPEND="dev-libs/glib:2
	dev-cpp/gtkmm:2.4
	x11-libs/gtksourceview:2.0
	>=dev-libs/gdl-2.26.2
	x11-libs/vte
	>=sci-mathematics/octave-3.2
	dev-lang/perl
	opengl? ( x11-libs/gtkglarea:2 )
	webkit? ( net-libs/webkit-gtk
		dev-libs/xapian )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_configure() {
	econf \
		--without-octave300 \
		$(use_with opengl glrenderer) \
		$(use_with webkit)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS ChangeLog NEWS README

	make_desktop_entry /usr/bin/octavede
}
