# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/pmount/pmount-0.9.6.ebuild,v 1.6 2006/01/04 19:35:14 cardoe Exp $

inherit eutils flag-o-matic

DESCRIPTION="Policy based mounter that gives the ability to mount removable devices as a user"
HOMEPAGE="http://www.piware.de/projects.shtml"
SRC_URI="http://www.piware.de/projects/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="crypt"

DEPEND=">=sys-apps/dbus-0.33
	>=sys-apps/hal-0.5.1
	>=sys-fs/sysfsutils-1.3.0
	crypt? ( sys-fs/cryptsetup-luks )"

DOCS="AUTHORS CHANGES"

pkg_setup() {
	enewgroup plugdev
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -e 's:/sbin/cryptsetup:/bin/cryptsetup:' -i src/policy.h
	append-ldflags $(bindnow-flags)
}

src_install () {
	#this is where we mount stuff
	keepdir /media

	# Must be run SETUID
	exeinto /usr/bin
	exeopts -m 4710 -g plugdev
	doexe src/pmount src/pumount src/pmount-hal

	dodoc AUTHORS ChangeLog TODO
	doman man/pmount.1 man/pumount.1 man/pmount-hal.1

	insinto /etc
	doins etc/pmount.allow
}

pkg_postinst() {
	einfo
	einfo "This package has been installed setuid.  The permissions are as such that"
	einfo "only users that belong to the plugdev group are allowed to run this."
	einfo
	einfo "Please add your user to the plugdev group to be able to mount USB drives"
}
