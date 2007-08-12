# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep-2

DESCRIPTION="A clone of the NeXTstep Interface Builder application for GNUstep"
HOMEPAGE="http://www.gnustep.org/experience/Gorm.html"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/dev-apps/${P}.tar.gz"

KEYWORDS="amd64 x86 ~ppc"
LICENSE="GPL-2"
SLOT="0"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i -e "/DOCUMENT_NAME =.*/a \Gorm_DOC_INSTALL_DIR=Developer/Gorm" \
		-e "/DOCUMENT_TEXT_NAME =.*/a \ANNOUNCE_DOC_INSTALL_DIR=Developer/Gorm/ReleaseNotes" \
		-e "/DOCUMENT_TEXT_NAME =.*/a \README_DOC_INSTALL_DIR=Developer/Gorm/ReleaseNotes" \
		-e "/DOCUMENT_TEXT_NAME =.*/a \NEWS_DOC_INSTALL_DIR=Developer/Gorm/ReleaseNotes" \
		-e "/DOCUMENT_TEXT_NAME =.*/a \INSTALL_DOC_INSTALL_DIR=Developer/Gorm/ReleaseNotes" \
		${S}/Documentation/GNUmakefile
}
