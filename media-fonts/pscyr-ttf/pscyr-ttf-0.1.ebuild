EAPI="7"

inherit font 

DESCRIPTION="Some PSCyr fonts, converted to TTF"
HOMEPAGE=""
SRC_URI="http://lizard.phys.msu.su/home/compu_sci/Antiqua.tar.gz -> ${PN}-antiqua-${PV}.tar.gz
http://lizard.phys.msu.su/home/compu_sci/Baltica.tar.gz -> ${PN}-baltica-${PV}.tar.gz
http://lizard.phys.msu.su/home/compu_sci/Journal.tar.gz -> ${PN}-journal-${PV}.tar.gz"

FONT_SUPPLIER="pscyr"
S=${WORKDIR}
FONT_S=${WORKDIR}
FONT_SUFFIX="ttf"

LICENSE="as-is"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sh sparc x86"
IUSE=""
RESTRICT="nostrip"

DEPEND=""
RDEPEND=""

