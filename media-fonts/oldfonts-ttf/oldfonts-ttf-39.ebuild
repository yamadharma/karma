EAPI="7"

inherit font

DESCRIPTION="The package includes several Russian book font families"
HOMEPAGE="http://lizard.phys.msu.su/home/compu_sci"
SRC_URI="http://lizard.phys.msu.su/home/compu_sci/OldFonts-dist-${PV}.tar.bz2
	doc? ( http://lizard.phys.msu.su/home/compu_sci/sample-${PV}.pdf )"

#S=${WORKDIR}/texmf/fonts/truetype
#FONT_S=${WORKDIR}
#FONT_SUFFIX="ttf"

S=${WORKDIR}

LICENSE="as-is"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sh sparc x86"
IUSE="+doc"
RESTRICT="nostrip"

DEPEND=""
RDEPEND=""

#FONT_S="paratype/courier paratype/pushkin public/oldfonts/academyo public/oldfonts/drevneru public/oldfonts/elizavet public/oldfonts/latin public/oldfonts/newstand"

src_install() {
	dodir /usr/share/fonts
	cp -R ${S}/texmf/fonts/truetype/* ${D}/usr/share/fonts
	
	dodir /usr/share/texmf-site
	cp -R ${S}/texmf/* ${D}/usr/share/texmf-site

#	for FONT_DIR in paratype/courier paratype/pushkin public/oldfonts/academyo public/oldfonts/drevneru public/oldfonts/elizavet public/oldfonts/latin public/oldfonts/newstand
#	do
#	cd ${S}/${FONT_DIR}
#	font_src_install
#	done

	cd ${S}
	dodoc README* INSTALL* Install* COPYRIGHT
	use doc && dodoc ${DISTDIR}/sample-${PV}.pdf
}
