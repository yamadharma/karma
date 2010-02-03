# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

FROM_LANG="Russian"
TO_LANG="English"
DICT_PREFIX="dictd_www.mova.org_"
DICT_SUFFIX="korolew_ruen"

inherit stardict

DESCRIPTION="Stardict Dictionary for Mova.org's Korolev's Dictionary"
HOMEPAGE="http://stardict.sourceforge.net/Dictionaries_dictd-www.mova.org.php"

KEYWORDS="amd64 ppc sparc x86"
IUSE=""

RDEPEND=">=app-text/stardict-${PV}"

src_compile() {
	cd ${S}
	gzip *.idx
}

stardict_src_install() {
	insinto /usr/share/stardict/dic
	doins *.dict.dz
	doins *.idx.gz
	doins *.ifo
}
												
