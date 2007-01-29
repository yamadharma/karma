# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

## This is actually a git snapshot.  There is no upstream maintainer however
## so I made the release.
inherit mono eutils

DESCRIPTION="A message bus system, a simple way for applications to talk to each other"
HOMEPAGE="http://dbus.freedesktop.org/"
SRC_URI="http://dev.gentoo.org/~steev/distfiles/${P}.tar.gz"

SLOT="0"
LICENSE="|| ( GPL-2 AFL-2.1 )"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc x86"
IUSE="doc"

RDEPEND=">=sys-apps/dbus-0.91
	>=dev-lang/mono-0.95
	=dev-dotnet/gtk-sharp-1.0*"

DEPEND="${RDEPEND}
	doc? ( >=dev-util/monodoc-1.1.10 )
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-0.6.3-connection_close.patch
	econf $(use_enable doc mono-docs)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README
}
