# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion kde

ESVN_REPO_URI="svn://anonsvn.kde.org/home/kde/branches/extragear/kde3/network/knetworkmanager"

DESCRIPTION="A NetworkManager front-end for KDE"
HOMEPAGE="http://en.opensuse.org/Projects/KNetworkManager"
LICENSE="GPL-2"
SRC_URI=""
KEYWORDS="amd64 x86"

DEPEND="net-misc/networkmanager
	>=kde-base/kdelibs-3.2
	|| ( >=dev-libs/dbus-qt3-old-0.70 ( =sys-apps/dbus-0.62-r1 ) )
	sys-apps/hal"

#S="${WORKDIR}/${PN}-${PV##*_p}"

pkg_setup() {
	kde_pkg_setup

	if has_version "<sys-apps/dbus-0.9*" && ! built_with_use sys-apps/dbus qt3 ; then
		echo
		eerror "You must rebuild sys-apps/dbus with USE=\"qt3\""
		die "sys-apps/dbus not built with qt3 bindings"
	fi
}

src_unpack() {
	ewarn "This ebuild checks out several svn repositories."
	ewarn "This may take a while."

	# Set the original uri to a temp var
	ESVN_REPO_URI1=${ESVN_REPO_URI}

	# Checkout kdereview
	ESVN_REPO_URI="svn://anonsvn.kde.org/home/kde/trunk/kdereview"
	ESVN_OPTIONS="-N"
	subversion_src_unpack

	# Checkout admin
	ESVN_REPO_URI="svn://anonsvn.kde.org/home/kde/branches/KDE/3.5/kde-common/admin"
	ESVN_OPTIONS=""
	S="${S}/admin"
	subversion_src_unpack

	# Checkout knetworkmanager
	ESVN_REPO_URI=${ESVN_REPO_URI1}
	S="${S}/../${PN}"
	subversion_src_unpack

	epatch "${FILESDIR}/knetworkmanager-pam_console-fix.patch"
	epatch "${FILESDIR}/knetworkmanager-libnl_u64-fix.patch"
}

pkg_postinst() {
	kde_pkg_postinst
	echo
	ewarn "DO NOT report bugs to Gentoo's bugzilla"
	einfo "Please report all bugs at http://bugs.gentoo-xeffects.orgg"
	einfo "Thank you on behalf of the Gentoo Xeffects team"
}

