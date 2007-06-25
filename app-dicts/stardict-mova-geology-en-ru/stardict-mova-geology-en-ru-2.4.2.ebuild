# Makurin Roman, 2003
# Distributed under the terms of the GNU General Public License v2

FROM_LANG="English"
TO_LANG="Russian"
DICT_PREFIX="dictd_www.mova.org_"
DICT_SUFFIX="geology_enru"

inherit stardict

DESCRIPTION="Stardict Dictionary for Mova.org's Dictionary"
HOMEPAGE="http://stardict.sourceforge.net/Dictionaries_dictd-www.mova.org.php"

KEYWORDS="amd64 ppc sparc x86"
IUSE=""

RDEPEND=">=app-dicts/stardict-${PV}"

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
