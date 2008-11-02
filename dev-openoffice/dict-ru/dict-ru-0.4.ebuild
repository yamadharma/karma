# Copyright 2006-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit openoffice-ext

DESCRIPTION="Russian Dictionaries and Thesaurus (combined ru_RU and ru_RU_yo)"
LICENSE="LGPL-2.1 myspell-ru_RU-ALexanderLebedev"
HOMEPAGE="http://lingucomponent.openoffice.org/
	http://extensions.services.openoffice.org/project/dict_ru_RU"
SRC_URI="http://extensions.services.openoffice.org/files/936/7/dict_ru_RU-${PV}.oxt"
SLOT="0"

KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ~ppc64 sparc x86 ~x86-fbsd"

S=${WORKDIR}

RDEPEND=">=app-office/openoffice-3"

OOO_EXTENSIONS=dict_ru_RU.oxt

src_unpack() {
	cp ${DISTDIR}/dict_ru_RU-${PV}.oxt ${S}/dict_ru_RU.oxt
}
