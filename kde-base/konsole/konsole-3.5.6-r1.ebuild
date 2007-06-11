# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/konsole/konsole-3.5.6-r1.ebuild,v 1.1 2007/04/30 20:05:31 carlo Exp $

KMNAME=kdebase
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="X terminal for use with KDE."
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE="kdehiddenvisibility transparency"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libXtst"

DEPEND="${RDEPEND}
	x11-apps/bdftopcf"

# For kcm_konsole module
RDEPEND="${RDEPEND}
	kde-base/kcontrol"

if use transparency ; then
	PATCHES="${FILESDIR}/${PN}-transparency.patch"
fi

