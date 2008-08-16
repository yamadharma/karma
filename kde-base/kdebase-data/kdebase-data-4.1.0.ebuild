# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

KMNAME=kdebase-runtime
KMNOMODULE=true
inherit kde4overlay-meta

DESCRIPTION="Icons, localization data and various .desktop files from kdebase."
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=">=kde-base/qimageblitz-0.0.4"
RDEPEND="${DEPEND}"

KMEXTRA="l10n/
	pics/"
# Note that the eclass doesn't do this for us, because of KMNOMODULE="true".
KMEXTRACTONLY="config-runtime.h.cmake kde4"

src_install() {
	kde4overlay-meta_src_install
	# Images provided by digikam package
	for SIZE in 16x16 22x22 32x32 48x48 64x64 128x128;
	do
		rm "${D}/usr/kde/4.1/share/icons/oxygen/${SIZE}/apps/digikam.png"
	done
	rm "${D}/usr/kde/4.1/share/icons/oxygen/scalable/apps/digikam.svgz"
}
