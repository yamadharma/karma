# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils versionator

DESCRIPTION="bzr-gtk is a plugin for Bazaar that aims to provide GTK+ interfaces to most Bazaar operations."
HOMEPAGE="http://bazaar-vcs.org/bzr-gtk"
SRC_URI="http://samba.org/~jelmer/bzr/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND=">=dev-lang/python-2.4
	=dev-util/bzr-$(get_version_component_range 1-2)*
	>=dev-python/pygtk-2.8
	>=dev-python/pycairo-1.0
	x11-libs/gtksourceview"
RDEPEND="${DEPEND}"

DOCS="README TODO"
