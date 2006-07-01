# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/gnome-base/gnome/gnome-2.4.ebuild,v 1.10 2003/11/15 02:54:10 agriffis Exp $

S=${WORKDIR}

DESCRIPTION="Meta package for the GNUstep desktop."
HOMEPAGE="http://www.gnustep.org/"
LICENSE="as-is"
SLOT="0"

IUSE=""

GUI_PV=0.9.2

# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="x86 ~amd64 ~ppc ~alpha ~sparc ~hppa ~ia64"

#  Note to developers:
#  This is a wrapper for the complete GNUstep desktop,
#  This means all components that a user expects in GNUstep are present
#  please do not reduce this list further unless
#  dependencies pull in what you remove.
#  With "emerge gnustep" a user expects the full "standard" distribution of GNUstep and should be 
#  provided with that, consider only installing the parts needed for smaller installations.

RDEPEND=">=gnustep-base/gnustep-make-${PV}
	>=gnustep-base/gnustep-base-${PV}
	>=gnustep-base/gnustep-gui-${GUI_PV}
	>=gnustep-base/gnustep-back-${GUI_PV}"

# Fonts	
RDEPEND="${RDEPEND}	
	media-fonts/freefont
	media-fonts/corefonts
	media-fonts/urw
	"

RDEPEND="${RDEPEND}		
	>=x11-wm/windowmaker-0.80.1
	"

# Core Applications
RDEPEND="${RDEPEND}		
	gnustep-apps/gworkspace
	gnustep-apps/gsdefaults
	gnustep-apps/prefsapp-cvs
	gnustep-apps/terminal
	gnustep-apps/addresses
	gnustep-apps/helpviewer
	"
# Text Applications
RDEPEND="${RDEPEND}		
	gnustep-apps/textedit-cvs
	"


# Graphic Applications
RDEPEND="${RDEPEND}		
	media-gfx/imageviewer
	media-gfx/preview
	media-gfx/viewpdf
	"
#	media-gfx/imagesmanager

# Communication Applications
RDEPEND="${RDEPEND}		
	net-mail/gnumail
	"
	


pkg_postinst () 
{
	einfo "note that to change windowmanager to Window Maker do: "
	einfo " export WINDOW_MANAGER=\"/usr/bin/wmaker\""
	einfo "of course this works for all other window managers as well"
}

# Local Variables:
# mode: sh
# End:
