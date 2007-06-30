# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdesktop/kdesktop-3.5.7.ebuild,v 1.2 2007/05/23 10:30:26 carlo Exp $

KMNAME=kdebase
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

SRC_URI="${SRC_URI}
	mirror://gentoo/kdebase-3.5-patchset-05.tar.bz2"

DESCRIPTION="KDesktop is the KDE interface that handles the icons, desktop popup menus and the screensaver system."
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="kdehiddenvisibility pertty xscreensaver"

DEPEND="$(deprange $PV $MAXKDEVER kde-base/libkonq)
	$(deprange $PV $MAXKDEVER kde-base/kcontrol)
	xscreensaver? ( x11-proto/scrnsaverproto )"
	# Requires the desktop background settings module,
	# so until we separate the kcontrol modules into separate ebuilds :-),
	# there's a dep here
RDEPEND="${DEPEND}
	$(deprange 3.5.6 $MAXKDEVER kde-base/kcheckpass)
	$(deprange 3.5.5 $MAXKDEVER kde-base/kdialog)
	$(deprange $PV $MAXKDEVER kde-base/konqueror)
	xscreensaver? ( x11-libs/libXScrnSaver )"

KMCOPYLIB="libkonq libkonq/"
KMEXTRACTONLY="kcheckpass/kcheckpass.h
	libkonq/
	kdm/kfrontend/themer/
	kioslave/thumbnail/configure.in.in" # for the HAVE_LIBART test
KMCOMPILEONLY="kcontrol/background
	kdmlib/"
KMNODOCS=true

PATCHES=""

if use pertty;
then
	PATCHES="${PATCHES}
		 	 ${FILESDIR}/$KMNAME-3.5.5-$PN-rounded-text-box-corners.patch"
fi

pkg_setup() {
	kde_pkg_setup
	if use pertty && ! built_with_use --missing false =kde-base/kdelibs-3.5* pertty;
	then
		eerror "The pertty USE flag in this package enables special extensions"
		eerror "and requires that kdelibs be patched to support these extensions."
		eerror "Since it appears your version of kdelibs was not compiled with these"
		eerror "extensions, you must either emerge kdesktop without pertty or"
		eerror "re-emerge kdelibs with pertty enabled and then emerge kdesktop again."
		die "Missing pertty USE flag on kde-base/kdelibs"
	fi
}

src_unpack() {
	kde-meta_src_unpack
	# see bug #143375
	sed  -e "s:SUBDIRS = . lock pics patterns programs init:SUBDIRS = . lock pics patterns programs:" \
		-i kdesktop/Makefile.am
}

src_compile() {
	myconf="${myconf} $(use_with xscreensaver)"
	kde-meta_src_compile
}

src_install() {
	# ugly, needs fixing: don't install kcontrol/background
	kde-meta_src_install

	rmdir "${D}/${PREFIX}/share/templates/.source/emptydir"
}

pkg_postinst() {
	kde_pkg_postinst
	mkdir -p "${PREFIX}/share/templates/.source/emptydir"
	echo
	ewarn "Do NOT report bugs to Gentoo's bugzilla"
	einfo "Please report all bugs to roderick.greening@gmail.com"
	einfo "Or, you may post them to http://forums.gentoo-xeffects.org"
	einfo "Thank you on behalf of the Gentoo Xeffects team"
}
