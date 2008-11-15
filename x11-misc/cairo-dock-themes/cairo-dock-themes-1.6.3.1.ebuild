# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

WANT_AUTOCONF=latest
WANT_AUTOMAKE=latest
inherit autotools eutils

# Upstream sources use date instead version number
# MY_PV="1.6.2.3"
MY_PV=${PV}

DESCRIPTION="The themes for the cairo-dock panel"
HOMEPAGE="http://developer.berlios.de/projects/cairo-dock/"
SRC_URI="http://download2.berlios.de/cairo-dock/cairo-dock-themes-${MY_PV}.tar.bz2"

LICENSE="GPL"
SLOT="0"
KEYWORDS="amd64 ppc x86"

MYTHEMES="Brit Clear MacOSX Neon2 Wood"

IUSE="${MYTHEMES}"

DEPEND="x11-misc/cairo-dock"

RDEPEND=${DEPEND}


S="${WORKDIR}/cairo-dock-themes-${MY_PV}"

src_unpack() {
	unpack cairo-dock-themes-${MY_PV}.tar.bz2
	cd "${S}"
	einfo "Patching Makefile.am to comply with USE flags"
	echo -n "SUBDIRS = " >Makefile.am
	for thistheme in ${MYTHEMES}; do
		if use ${thistheme}; then
			echo -en "\\ \n\t_${thistheme}_" >>Makefile.am
#			sed s/_${thistheme}_\\// <Makefile.am >tmp.am
#			mv tmp.am Makefile.am
		fi
	done
	echo -en "\n" >>Makefile.am
	eautoreconf || die "eautoreconf failed"
	econf || die "econf failed"
}

src_compile() {
	cd "${S}"
	emake || die "emake failed"
}

src_install() {
	cd "${S}"
	emake DESTDIR="${D}" install || die "emake install failed"
}
