# Copyright
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils paludis-hooks

DESCRIPTION="Hook update-eix makes eix work with Paludis."

KEYWORDS="amd64 x86"

DEPEND="${DEPEND}
	app-portage/eix"

RDEPEND="${DEPEND}"

src_install() {
	dohook update-eix.bash sync_all_pre sync_all_post
}
