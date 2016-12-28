# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

SUFFIX=+nmu2

DESCRIPTION="Library that implements digital image warping, known as morphing, along with GUIs."
HOMEPAGE="http://xmorph.sourceforge.net/"
SRC_URI="mirror://debian/pool/main/x/xmorph/${PN}_${PV}${SUFFIX}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="gtk nls fftw"
# Options I'm ignoring:
# --with-waili --with-xmorph --with-tkmorph

#		--disable-gtktest \
#		--without-gtkmorph	\ 

S=${WORKDIR}/${PN}-${PV}${SUFFIX}

RDEPEND="nls? ( virtual/libintl )
		 gtk? ( x11-libs/gtk+ )"

DEPEND="nls? ( sys-devel/gettext )
		gtk? ( x11-libs/gtk+ )
		fftw? ( >=sci-libs/fftw-3 )"
src_prepare() {
	epatch ${FILESDIR}/gcc5.patch
	./autogen.sh
}

src_compile() {
	econf \
		$(use_enable nls) \
		$(use_with gtk gtkmorph) \
		$(use_with fftw) \
		  || die "configure failed"
	
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
}
