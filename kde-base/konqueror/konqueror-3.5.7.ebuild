# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/konqueror/konqueror-3.5.7.ebuild,v 1.1 2007/05/23 00:44:15 carlo Exp $

KMNAME=kdebase
# Note: we need >=kdelibs-3.3.2-r1, but we don't want 3.3.3!
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE: Web browser, file manager, ..."
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="java kdehiddenvisibility pertty"

DEPEND="
$(deprange $PV $MAXKDEVER kde-base/libkonq)"

RDEPEND="${DEPEND}
$(deprange $PV $MAXKDEVER kde-base/kcontrol)
$(deprange $PV $MAXKDEVER kde-base/kdebase-kioslaves)
$(deprange $PV $MAXKDEVER kde-base/kfind)
java? ( >=virtual/jre-1.4 )"

KMCOPYLIB="libkonq libkonq"
KMEXTRACTONLY=kdesktop/KDesktopIface.h

if use pertty;
then
	PATCHES="$FILESDIR/$KMNAME-3.5.6-$PN-execute_feedback.patch
		 	 $FILESDIR/$KMNAME-3.5.5-$PN-homepage-newtab.patch
		 	 $FILESDIR/$KMNAME-3.5.5-$PN-rubberband.patch
		 	 $FILESDIR/$KMNAME-3.5.5-$PN-sidebar-tng.patch"
fi

pkg_preinst() {
	kde_pkg_preinst

	# We need to symlink here, as kfmclient freaks out completely,
	# if it does not find konqueror.desktop in the legacy path.
	dodir ${PREFIX}/share/applications/kde
	dosym ../../applnk/konqueror.desktop ${PREFIX}/share/applications/kde/konqueror.desktop
}

pkg_setup() {
	if use pertty && ! built_with_use --missing true kde-base/libkonq pertty;
	then
		eerror "The pertty USE flag in this package enables special extensions"
		eerror "and requires that libkonq be patched to support these extensions."
		eerror "Since it appears your version of libkonq was not compiled with these"
		eerror "extensions, you must either emerge konqueror without pertty or"
		eerror "re-emerge libkonq with pertty enabled and then emerge konqueror again."
		die "Missing pertty USE flag on kde-base/libkonq"
	fi
}

pkg_postinst() {
	kde_pkg_postinst
	echo
	ewarn "DO NOT report bugs to Gentoo's bugzilla"
	einfo "Please report all bugs to http://trac.gentoo-xeffects.org"
	einfo "Thank you on behalf of the Gentoo Xeffects team"
}
