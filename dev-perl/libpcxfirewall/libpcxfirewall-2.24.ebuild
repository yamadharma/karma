# Copyright 1999-2005 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit perl-module

IUSE=""

DESCRIPTION="Command line util for managing firewall rules (library)"
HOMEPAGE="http://pcxfirewall.sourceforge.net/"
SRC_URI="mirror://sourceforge/pcxfirewall/${PN}-perl-${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="x86 amd64"
SLOT="0"

S=${WORKDIR}/${PN}-perl-${PV}

DEPEND="${DEPEND}"
RDEPEND="${DEPEND}"

	


