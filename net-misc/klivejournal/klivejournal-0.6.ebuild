# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde
need-kde 3

DESCRIPTION="KLiveJournal is a KDE client for the LiveJournal.com."
SRC_URI="mirror://sourceforge/${PN}/KLiveJournal-${PV}.tar.bz2"
HOMEPAGE="http://${PN}.sourceforge.net"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc amd64 ~sparc"
IUSE=""

S=${WORKDIR}/KLiveJournal
