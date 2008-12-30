# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

FROM_LANG="English"
TO_LANG="Russian"
DICT_PREFIX=""
DICT_SUFFIX="en-ru-bars"
#jjhttp://prdownloads.sourceforge.net/stardict/stardict-en-ru-bars-2.4.2.tar.bz2?download

inherit stardict

DESCRIPTION="Probably best ${FROM_LANG} into ${TO_LANG} dictionary"
HOMEPAGE="http://stardict.sourceforge.net/Dictionaries_dictd-www.mova.org.php"

KEYWORDS="x86 amd64"
IUSE=""
