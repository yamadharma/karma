# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit perl-module

MY_PN="Gtk2-ImageView"
MY_P=${MY_PN}-${PV}

DESCRIPTION="Bindings for the GtkImageView image viewer"
HOMEPAGE="http://search.cpan.org/search?query=${MY_PN}&mode=dist"
SRC_URI="mirror://cpan/authors/id/R/RA/RATCLIFFE/${MY_P}.tar.gz"

IUSE=""

SLOT="0"
LICENSE="LGPL-3"
KEYWORDS="amd64 x86"

DEPEND=">=dev-perl/extutils-depends-0.300
	>=dev-perl/extutils-pkgconfig-1.11
	>=dev-perl/glib-perl-1.182
	>=dev-perl/gtk2-perl-1.182
	>=dev-perl/Cairo-1.00
	>=media-gfx/gtkimageview-1.6.1
	dev-lang/perl"

S=${WORKDIR}/${MY_P}
