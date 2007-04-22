# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnustep subversion

ESVN_OPTIONS="-r${PV/*_pre}"
ESVN_REPO_URI="http://svn.gna.org/svn/gnustep/apps/systempreferences/trunk"
ESVN_STORE_DIR="${PORTAGE_ACTUAL_DISTDIR-${DISTDIR}}/svn-src/svn.gna.org/gnustep/apps"

#S=${WORKDIR}/${P/gw/GW}

DESCRIPTION="System Preferences is a clone of the Apple OS X System Preferences application based on a GNUstep implementation of the PreferencePanes framework."
HOMEPAGE="http://www.gnustep.it/enrico/system-preferences/"
#SRC_URI="http://www.gnustep.it/enrico/system-preferences/${P}.tar.gz"

KEYWORDS="~ppc x86 amd64"
LICENSE="GPL-2"
SLOT="0"

IUSE=""

DEPEND="${GS_DEPEND}"
RDEPEND="${GS_RDEPEND}"

egnustep_install_domain "System"

DIRS="PreferencePanes SystemPreferences Modules"

src_unpack () 
{
	subversion_src_unpack
#	unpack ${A}
	cd ${S}
	
	egnustep_env
	
	echo "ADDITIONAL_INCLUDE_DIRS += -I${S}" >> SystemPreferences/GNUmakefile.preamble
	echo "ADDITIONAL_LIB_DIRS += -L${S}/PreferencePanes/PreferencePanes.framework/Versions/Current -L${S}/PreferencePanes/PreferencePanes.framework/Versions/Current/$GNUSTEP_HOST_CPU/$GNUSTEP_HOST_OS/$LIBRARY_COMBO" >> SystemPreferences/GNUmakefile.preamble
	
	echo "ADDITIONAL_INCLUDE_DIRS += -I${S}" >> Modules/GNUmakefile.preamble
	echo "ADDITIONAL_LIB_DIRS += -L${S}/PreferencePanes/PreferencePanes.framework/Versions/Current -L${S}/PreferencePanes/PreferencePanes.framework/Versions/Current/$GNUSTEP_HOST_CPU/$GNUSTEP_HOST_OS/$LIBRARY_COMBO" >> Modules/GNUmakefile.preamble
	
	cd Modules
	find . -type d -maxdepth 1 \
	| while read target
	do
	    echo "ADDITIONAL_INCLUDE_DIRS += -I${S}" >> ${target}/GNUmakefile.preamble
	    echo "ADDITIONAL_LIB_DIRS += -L${S}/PreferencePanes/PreferencePanes.framework/Versions/Current -L${S}/PreferencePanes/PreferencePanes.framework/Versions/Current/$GNUSTEP_HOST_CPU/$GNUSTEP_HOST_OS/$LIBRARY_COMBO" >> ${target}/GNUmakefile.preamble
	done
}

src_compile () 
{
	egnustep_env

	for i in ${DIRS}
	do
	    cd ${S}/${i}
	    egnustep_make || die
	done
}

src_install () 
{
	egnustep_env

	for i in ${DIRS}
	do
	    cd ${S}/${i}
	    egnustep_install || die
	done
}

