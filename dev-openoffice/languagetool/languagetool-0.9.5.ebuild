# Copyright 2006-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit openoffice-ext

DESCRIPTION="LanguageTool is an Open Source language checker for English, German, Polish, Dutch, and other languages"
LICENSE="LGPL-3"
HOMEPAGE="http://www.languagetool.org/
	http://extensions.services.openoffice.org/project/Languagetool"
SRC_URI="http://www.languagetool.org/download/LanguageTool-${PV}.oxt"
SLOT="0"

KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ~ppc64 sparc x86 ~x86-fbsd"

S=${WORKDIR}

OOO_EXTENSIONS=LanguageTool.oxt

src_unpack() {
	cp ${DISTDIR}/LanguageTool-${PV}.oxt ${S}/LanguageTool.oxt
}
