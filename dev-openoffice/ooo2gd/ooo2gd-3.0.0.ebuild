# Copyright 2006-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

OO_EXTENSIONS=(${PN}.oxt)

inherit office-ext

DESCRIPTION="OpenOffice.org2GoogleDocs - export & import to Google Docs, Zoho, WebDAV"
LICENSE="LGPL-3"
HOMEPAGE="http://code.google.com/p/ooo2gd/
	http://extensions.services.openoffice.org/project/ooo2gd"
SRC_URI="http://ooo2gd.googlecode.com/files/${P/-/_}.oxt"
SLOT="0"
RESTRICT="nomirror"


KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ~ppc64 sparc x86 ~x86-fbsd"

S=${WORKDIR}

src_unpack() {
	cp ${DISTDIR}/${P/-/_}.oxt ${S}/${PN}.oxt
}
