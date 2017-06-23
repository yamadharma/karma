EAPI="2"

inherit font 

DESCRIPTION="The package includes several Russian book font families"
HOMEPAGE="http://lizard.phys.msu.su/home/compu_sci"
SRC_URI="http://lizard.phys.msu.su/home/compu_sci/OldFonts-dist-${PV}.tar.bz2"

S=${WORKDIR}/texmf/fonts/truetype
FONT_S=${WORKDIR}
FONT_SUFFIX="ttf"

LICENSE="as-is"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sh sparc x86"
IUSE=""
RESTRICT="nostrip"

DEPEND=""
RDEPEND=""

#FONT_S="paratype/courier paratype/pushkin public/oldfonts/academyo public/oldfonts/drevneru public/oldfonts/elizavet public/oldfonts/latin public/oldfonts/newstand"

src_install() {
	for FONT_S in paratype/courier paratype/pushkin public/oldfonts/academyo public/oldfonts/drevneru public/oldfonts/elizavet public/oldfonts/latin public/oldfonts/newstand
	do
	font_src_install
	done
}
