# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde eutils

DESCRIPTION="kde remote dekstop connections manager"
HOMEPAGE="http://krdm.sourceforge.net/"
SRC_URI="mirror://sourceforge/krdm/${P/+-src}.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=""
RDEPEND="net-misc/rdesktop
	net-misc/tightvnc"

S="${WORKDIR}/${PN}"

need-kde 3.4

