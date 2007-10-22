# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/konqueror/konqueror-3.5.8.ebuild,v 1.1 2007/10/19 23:16:09 philantrop Exp $

KMNAME=kdebase
# Note: we need >=kdelibs-3.3.2-r1, but we don't want 3.3.3!
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

SRC_URI="${SRC_URI}
	mirror://gentoo/kdebase-3.5-patchset-06.tar.bz2
	pertty? (
		http://distfiles.gentoo-xeffects.org/pertty/$KMNAME-3.5.5-$PN-sidebar-tng.patch.bz2
	)"

DESCRIPTION="KDE: Web browser, file manager, ..."
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE="branding java kdehiddenvisibility pertty"

DEPEND="
$(deprange $PV $MAXKDEVER kde-base/libkonq)"

RDEPEND="${DEPEND}
	$(deprange $PV $MAXKDEVER kde-base/kcontrol)
	$(deprange $PV $MAXKDEVER kde-base/kdebase-kioslaves)
	$(deprange $PV $MAXKDEVER kde-base/kfind)
	java? ( >=virtual/jre-1.4 )"

PATCHES=""

KMCOPYLIB="libkonq libkonq"
KMEXTRACTONLY=kdesktop/KDesktopIface.h

if use pertty;
then
	PATCHES="${PATCHES}
			 ${FILESDIR}/$KMNAME-3.5.6-$PN-execute_feedback.patch
			 ${FILESDIR}/$KMNAME-3.5.8-$PN-homepage-newtab.patch
			 ${FILESDIR}/$KMNAME-3.5.5-$PN-rubberband.patch
			 ${DISTDIR}/$KMNAME-3.5.5-$PN-sidebar-tng.patch.bz2"
fi

pkg_preinst() {
	kde_pkg_preinst

	# We need to symlink here, as kfmclient freaks out completely,
	# if it does not find konqueror.desktop in the legacy path.
	dodir ${PREFIX}/share/applications/kde
	dosym ../../applnk/konqueror.desktop ${PREFIX}/share/applications/kde/konqueror.desktop
}

pkg_setup() {
	kde_pkg_setup
	if use pertty && ! built_with_use --missing true =kde-base/libkonq-3.5* pertty;
	then
		eerror "The pertty USE flag in this package enables special extensions"
		eerror "and requires that libkonq be patched to support these extensions."
		eerror "Since it appears your version of libkonq was not compiled with these"
		eerror "extensions, you must either emerge konqueror without pertty or"
		eerror "re-emerge libkonq with pertty enabled and then emerge konqueror again."
		die "Missing pertty USE flag on kde-base/libkonq"
	fi
}

src_install() {
	kde_src_install

	if use branding ; then
		dodir ${PREFIX}/share/services/searchproviders
		insinto ${PREFIX}/share/services/searchproviders
		doins "${WORKDIR}/patches/*.desktop"
	fi
}

pkg_postinst() {
	kde_pkg_postinst

	if use branding ; then
		echo
		elog "We've added three Gentoo-related web shortcuts:"
		elog "- gb           Gentoo Bugzilla searching"
		elog "- gf           Gentoo Forums searching"
		elog "- gp           Gentoo Package searching"
		echo
		elog "You'll have to activate them in 'Configure Konqueror...'."
	fi
	echo
	elog "If you can't open new ${PN} windows and get something like"
	elog "'WARNING: Outdated database found' when starting ${PN} in a console, run"
	elog "kbuildsycoca as the user you're running KDE under."
	elog "This is NOT a bug."
	echo
	ewarn "Do NOT report bugs to Gentoo's bugzilla"
	einfo "Please report all bugs to roderick.greening@gmail.com"
	einfo "Or, you may post them to http://forums.gentoo-xeffects.org"
	einfo "Thank you on behalf of the Gentoo Xeffects team"
}
