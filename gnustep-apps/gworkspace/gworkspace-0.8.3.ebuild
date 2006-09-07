# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep

S=${WORKDIR}/${P/gw/GW}

DESCRIPTION="A workspace manager for GNUstep"
HOMEPAGE="http://www.gnustep.it/enrico/gworkspace/"
SRC_URI="http://www.gnustep.it/enrico/gworkspace/${P}.tar.gz"

KEYWORDS="~ppc ~x86"
LICENSE="GPL-2"
SLOT="0"

IUSE="pdf doc"
DEPEND="${GS_DEPEND}
	gnustep-apps/systempreferences
	>=dev-db/sqlite-3.2.8
	pdf? ( =gnustep-libs/pdfkit-0.9* )
	!gnustep-apps/desktop
	!gnustep-apps/recycler"
RDEPEND="${GS_RDEPEND}
	gnustep-apps/systempreferences
	>=dev-db/sqlite-3.2.8
	pdf? ( =gnustep-libs/pdfkit-0.9* )
	!gnustep-apps/desktop
	!gnustep-apps/recycler"

egnustep_install_domain "System"

src_unpack() {
	egnustep_env

	unpack ${A}

	# FIX compile mdextractor
	sed -i -e "s:-L../../DBKit:-L../../../DBKit:g" \
		-e "s:-I../../DBKit:-I../../../DBKit:g" \
		${S}/GWMetadata/gmds/mdextractor/GNUmakefile.preamble
}


src_compile() {
	egnustep_env

        # Non-flattened env
	export CPPFLAGS="$CPPFLAGS -I$GNUSTEP_SYSTEM_ROOT/Library/Headers -I$GNUSTEP_LOCAL_ROOT/Library/Headers -I$GNUSTEP_SYSTEM_ROOT/Library/Headers/$LIBRARY_COMBO -I$GNUSTEP_LOCAL_ROOT/Library/Headers/$LIBRARY_COMBO -I$GNUSTEP_SYSTEM_ROOT/Library/Headers/$LIBRARY_COMBO/$GNUSTEP_HOST_CPU/$GNUSTEP_HOST_OS -I$GNUSTEP_LOCAL_ROOT/Library/Headers/$LIBRARY_COMBO/$GNUSTEP_HOST_CPU/$GNUSTEP_HOST_OS"
	export LDFLAGS="$LDFLAGS -L$GNUSTEP_SYSTEM_ROOT/Library/Libraries -L$GNUSTEP_LOCAL_ROOT/Library/Libraries -L$GNUSTEP_SYSTEM_ROOT/Library/Libraries/$LIBRARY_COMBO -L$GNUSTEP_LOCAL_ROOT/Library/Libraries/$LIBRARY_COMBO -L$GNUSTEP_SYSTEM_ROOT/Library/Libraries/$GNUSTEP_HOST_CPU/$GNUSTEP_HOST_OS/$LIBRARY_COMBO -L$GNUSTEP_LOCAL_ROOT/Library/Libraries/$GNUSTEP_HOST_CPU/$GNUSTEP_HOST_OS/$LIBRARY_COMBO" 

	econf || die "configure failed"
	
	egnustep_make || die "make failed"
	
	cd ${S}/GWMetadata
	econf || die "GWMetadata configure failed"
	egnustep_make || die "GWMetadata make failed"
}

src_install() {
	egnustep_env

	egnustep_install

	cd ${S}/GWMetadata	
	egnustep_install
	
	if ( use doc ) 
	    then
	    dodir /usr/share/doc/${PF}
	    cp ${S}/Documentation/*.pdf ${D}/usr/share/doc/${PF}
	fi
}

