# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-base/gnustep-back-art/gnustep-back-art-0.11.0.ebuild,v 1.1 2006/09/03 21:17:12 grobian Exp $

inherit gnustep subversion

ESVN_PROJECT=back

ESVN_OPTIONS="-r${PV/*_pre}"
ESVN_REPO_URI="http://svn.gna.org/svn/gnustep/libs/${ESVN_PROJECT}/trunk"
ESVN_STORE_DIR="${PORTAGE_ACTUAL_DISTDIR-${DISTDIR}}/svn-src/svn.gna.org/gnustep/libs"

S=${WORKDIR}/${ESVN_PROJECT}

#S=${WORKDIR}/gnustep-back-${PV}

DESCRIPTION="libart_lgpl back-end component for the GNUstep GUI Library"

HOMEPAGE="http://www.gnustep.org"
# SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-back-${PV}.tar.gz"
KEYWORDS="amd64 ~ppc ~sparc x86"
SLOT="0"
LICENSE="LGPL-2.1"

PROVIDE="virtual/gnustep-back"

IUSE="${IUSE} opengl xim doc"
# from http://gnustep.made-it.com/BuildGuide/index.html#BUILDING.GNUSTEP
# gnustep-gui, libICE, libSM, libX11, libXext, libXi, libXmu, libXt,
# libGL, libXft, libXrender, libexpat, libfontconfig, libfreetype,
# libart
DEPEND="${GNUSTEP_CORE_DEPEND}
	gnustep-base/gnustep-make
	gnustep-base/gnustep-base
	gnustep-base/gnustep-gui
	opengl? ( virtual/opengl virtual/glu )
	|| (
		(
			x11-libs/libICE
			x11-libs/libSM
			x11-libs/libX11
			x11-libs/libXext
			x11-libs/libXi
			x11-libs/libXmu
			x11-libs/libXt
			x11-libs/libXft
			x11-libs/libXrender
		)
		(
			virtual/xft
			virtual/x11
		)
	)
	dev-libs/expat
	media-libs/fontconfig
	>=media-libs/freetype-2.1.9
	>=media-libs/libart_lgpl-2.3
	"
# 	!virtual/gnustep-back	
RDEPEND="${DEPEND}
	${DEBUG_DEPEND}
	${DOC_RDEPEND}
	media-fonts/dejavu"

egnustep_install_domain "System"

src_unpack() {
#	unpack ${A}
	subversion_src_unpack
	cd ${S}
#	EPATCH_OPTS="-d ${S}" epatch "${FILESDIR}/font-make-fix.patch-${PV}"

	# DejaVu font is successor of Bitstream Vera
	sed -i -e "s:BitstreamVeraSans-Roman:DejaVuSans:g" \
		-e "s:BitstreamVeraSansMono-Roman:DejaVuSansMono:g" \
		-e "s:BitstreamVeraSans-Bold:DejaVuSans-Bold:g" \
		"${S}/Source/art/ftfont.m"
}

src_compile() {
	egnustep_env

	use opengl && myconf="--enable-glx"
	myconf="$myconf `use_enable xim`"
	myconf="$myconf --enable-server=x11"
	myconf="$myconf --enable-graphics=art --with-name=art"
	econf $myconf || die "configure failed"

	egnustep_make
}

src_install() {
	egnustep_env

	gnustep_src_install 
	cd ${S}
	mkdir -p "${D}/$(egnustep_system_root)/Library/Fonts"
	cp -pPR Fonts/Helvetica.nfont "${D}/$(egnustep_system_root)/Library/Fonts"
	rm -rf "${D}/$(egnustep_system_root)/var"

	dosym \
		"$(egnustep_system_root)/Library/Bundles/libgnustep-art-012.bundle" \
		"$(egnustep_system_root)/Library/Bundles/libgnustep-art.bundle"
}

