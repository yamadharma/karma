# Copyright 2006-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit openoffice-ext

DESCRIPTION="This extention helps pasting content from web into text documents. Image files are loaded on the links and integrated into the document"
LICENSE="LGPL-3"
HOMEPAGE="http://wiki.i-rs.ru/wiki/RU/extensions/writer/pastefromweb
http://extensions.services.openoffice.org/en/project/PasteFromWeb"
SRC_URI="http://extensions.services.openoffice.org/e-files/ext/4849/1/PasteFromWeb.oxt -> PasteFromWeb-${PV}.oxt"
SLOT="0"

KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ~ppc64 sparc x86 ~x86-fbsd"

S=${WORKDIR}

OOO_EXTENSIONS=PasteFromWeb.oxt

src_unpack() {
	cp ${DISTDIR}/PasteFromWeb-${PV}.oxt ${S}/PasteFromWeb.oxt
}
