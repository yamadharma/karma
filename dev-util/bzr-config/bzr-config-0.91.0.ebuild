# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="GUI utility for configuring Bazaar settings."
HOMEPAGE="https://launchpad.net/bzr-config"
SRC_URI="https://launchpad.net/bzr-config/trunk/0.91.0/+download/bzr-config-0.91.0.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=">=dev-lang/python-2.4
	>=dev-util/bzr-0.14"
RDEPEND="${DEPEND}"

pkg_setup() {
	if ! built_with_use 'dev-lang/python' 'tk'; then
		eerror "${PN} uses Tkinter as the GUI toolkit, but Python was not built"
		eerror "with it!  Please re-emerge dev-lang/python with USE='tk'."
		die
	fi
}
