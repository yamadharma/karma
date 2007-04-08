# Copyright
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Authors of hook: compress-man
# -----------------------------
# pdouble

# Author of this ebuild:
# ----------------------
# zxy, dleverton (eclass)

inherit eutils paludis-hooks

DESCRIPTION="Hook compresses man and info pages if the package itself does not."

KEYWORDS="amd64 x86"

DEPEND="${DEPEND}
	app-misc/symlinks"

RDEPEND="${DEPEND}"

src_install() {
  	dohook compress-man-${PV}/compress-man.bash ebuild_install_post
}
