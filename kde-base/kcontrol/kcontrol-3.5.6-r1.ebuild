# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kcontrol/kcontrol-3.5.6-r1.ebuild,v 1.1 2007/04/30 19:56:48 carlo Exp $

KMNAME=kdebase
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

SRC_URI="${SRC_URI}
	mirror://gentoo/kdebase-3.5-patchset-04.tar.bz2"

DESCRIPTION="The KDE Control Center"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE="arts ieee1394 logitech-mouse opengl kdehiddenvisibility pertty"

DEPEND=">=media-libs/freetype-2
	media-libs/fontconfig
	dev-libs/openssl
	arts? ( $(deprange 3.5.5 $MAXKDEVER kde-base/arts) )
	opengl? ( virtual/opengl )
	ieee1394? ( sys-libs/libraw1394 )
	logitech-mouse? ( >=dev-libs/libusb-0.1.10a )"

RDEPEND="${DEPEND}
	sys-apps/usbutils
	$(deprange $PV $MAXKDEVER kde-base/kcminit)
	$(deprange $PV $MAXKDEVER kde-base/kdebase-data)
	$(deprange $PV $MAXKDEVER kde-base/kdesu)
	$(deprange $PV $MAXKDEVER kde-base/khelpcenter)
	$(deprange $PV $MAXKDEVER kde-base/khotkeys)
	$(deprange $PV $MAXKDEVER kde-base/libkonq)
	$(deprange $PV $MAXKDEVER kde-base/kicker)"

KMEXTRACTONLY="kwin/kwinbindings.cpp
		kicker/kicker/core/kickerbindings.cpp
		kicker/taskbar/taskbarbindings.cpp
		kdesktop/kdesktopbindings.cpp
		klipper/klipperbindings.cpp
		kxkb/kxkbbindings.cpp
		kicker/taskmanager"

KMEXTRA="doc/kinfocenter"
KMCOMPILEONLY="kicker/libkicker
	kicker/taskbar"
KMCOPYLIB="libkonq libkonq
	libkicker kicker/libkicker
	libtaskbar kicker/taskbar
	libtaskmanager kicker/taskmanager"

PATCHES=""

if use pertty; then
	PATCHES="${PATCHES}
		 ${FILESDIR}/$KMNAME-3.5.5-$PN-homepage-newtab.patch
	 	 ${FILESDIR}/$KMNAME-3.5.5-$PN-rubberband.patch"
fi

src_unpack() {
	kde-meta_src_unpack

	#
	# If we are using kickoff, then epatch here and extract icons
	#
	if has_version kde-base/kicker && built_with_use --missing false kde-base/kicker kickoff; then
		epatch "${FILESDIR}/$KMNAME-3.5.6-$PN-kickoff-suse.patch"
		# Add Xeffects/Gentoo changes
		epatch "${FILESDIR}/kickoff-kcontrol-gentoo-xeffects-integration-v3.patch"
	fi
}


pkg_setup() {
	if use pertty && has_version kde-base/konqueror && ! built_with_use --missing true kde-base/konqueror pertty; then
		eerror "The pertty USE flag in this package enables special extensions"
		eerror "and requires that konqueror be patched to support these extensions."
		eerror "Since it appears your version of konqueror was not compiled with these"
		eerror "extensions, you must either emerge kcontrol without pertty or"
		eerror "re-emerge konqueror with pertty enabled and then emerge kcontrol again."
		die "Enable the pertty USE flag on kde-base/konqueror"
	fi
}

src_compile() {
	myconf="$myconf --with-ssl $(use_with arts) $(use_with opengl gl)
			$(use_with ieee1394 libraw1394) $(use_with logitech-mouse libusb)
			--with-usbids=/usr/share/misc/usb.ids"
	kde-meta_src_compile
}

pkg_postinst() {
	kde_pkg_postinst
	echo
	ewarn "DO NOT report bugs to Gentoo's bugzilla"
	einfo "Please report all bugs to http://trac.gentoo-xeffects.org"
	einfo "Thank you on behalf of the Gentoo Xeffects team"
}
