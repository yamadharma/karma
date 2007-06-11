# Copyright 2006-2007 SabayonLinux
# Distributed under the terms of the GNU General Public License v2

inherit eutils toolchain-funcs

DESCRIPTION="D-Bus methods provided for convenience"
SRC_URI="http://www.sabayonlinux.org/distfiles/sys-libs/${PN}/liblazy-${PV}.tar.bz2"
HOMEPAGE=""

RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

# empty for now
RDEPEND=""
DEPEND=">=sys-apps/dbus-0.62"

src_install() {
	emake DESTDIR="${D}" install || die
}

pkg_postinst() {
	echo
	ewarn "DO NOT report bugs to Gentoo's bugzilla"
	einfo "Please report all bugs to http://trac.gentoo-xeffects.org"
	einfo "Thank you on behalf of the Gentoo Xeffects team"
}
