# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VALA_MIN_API_VERSION=0.22

inherit meson vala

DESCRIPTION="Switchboard plug to show system information"
HOMEPAGE="https://github.com/elementary/switchboard-plug-about"

#if [[ ${PV} == 9999 ]] ; then
#    EGIT_REPO_URI="https://github.com/elementary/switchboard-plug-about.git"
#    inherit git-r3
#else
SRC_URI="https://github.com/elementary/switchboard-plug-about/archive/${PV}.tar.gz -> ${P}.tar.gz"
#fi

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE="systemd"

RDEPEND="
	sys-apps/fwupd[introspection]
	sys-fs/udisks[introspection]
	dev-libs/glib:2
	dev-libs/granite:0
	pantheon-base/switchboard
	x11-libs/gtk+:3
	systemd? ( sys-apps/systemd )
	!systemd? ( app-admin/openrc-settingsd )
"
DEPEND="${RDEPEND}
	$(vala_depend)
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}/0001-Add-support-for-AppStream-1.0-275.patch" )

src_prepare() {
	default
	eapply_user
	vala_setup
}

pkg_postinst() {
	use systemd || einfo "Ensure openrc-settingsd is running when you want to use this plug."
}
