# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs versionator

MY_PV_AUX=-rc3-agnita
MY_PV=$(get_version_component_range 2- "${PV}" )${MY_PV_AUX}
MY_PV=${MY_PV//pre}
MY_P=${PN}-${MY_PV}

S=${WORKDIR}/${MY_P}

DESCRIPTION="window manager improved 2 -- the next generation of the WMI project."
HOMEPAGE="http://www.wmii.de"
SRC_URI="http://wmii.de/download/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc x86"
IUSE=""

DEPEND="|| ( x11-libs/libX11 virtual/x11 )"

src_unpack() {
	unpack "${A}"
	cd ${S}

	sed -i \
		-e "/^PREFIX/s/=.*/= \/usr/" \
		-e "/^CONFPREFIX/s/=.*/= \/etc/" \
		-e "/^CC/s/=.*/= $(tc-getCC)/" \
		-e "/^AR/s/=.*/= $(tc-getAR) cr/" \
		-e "/^RANLIB/s/=.*/= $(tc-getRANLIB)/" \
		-e "/^CFLAGS/s/-O0/${CFLAGS}/" \
		-e "/^LDFLAGS/s/-g /-g ${LDFLAGS} /" \
		"${S}/config.mk" || die "sed failed."
}

src_compile() {
	MAKEOPTS="-j1" # To keep the warnings away
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed."

	dodoc README LICENSE 
#	dodoc doc/NOTES doc/RELEASE doc/wmii.svg doc/wmii.tex || die "dodoc failed."

	echo -e "#!/bin/sh\nexec /usr/bin/wmii" > "${T}/${PN}"
	exeinto /etc/X11/Sessions
	doexe "${T}/${PN}" || die "/etc/X11/Sessions failed."

	insinto /usr/share/xsessions
	doins "${FILESDIR}/${PN}.desktop" || die "${PN}.desktop failed."
}
