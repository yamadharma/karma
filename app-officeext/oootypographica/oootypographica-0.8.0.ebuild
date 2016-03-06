# Copyright 2006-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit openoffice-ext

DESCRIPTION="Russian Typographica"
LICENSE="LGPL-3"
HOMEPAGE="http://extensions.services.openoffice.org/project/OOoTypographica"
SRC_URI="http://extensions.services.openoffice.org/files/1299/0/OOoTypographica-${PV}.oxt"
SLOT="0"

KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ~ppc64 sparc x86 ~x86-fbsd"

S=${WORKDIR}

OOO_EXTENSIONS=OOoTypographica.oxt

src_unpack() {
	cp ${DISTDIR}/OOoTypographica-${PV}.oxt ${S}/OOoTypographica.oxt
}
