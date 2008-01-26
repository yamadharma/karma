# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
NEED_KDE=":kde-4"

inherit kde4-base subversion 

ESVN_OPTIONS="-r{${PV/*_pre}}"
ESVN_REPO_URI="http://krusader.svn.sourceforge.net/svnroot/krusader/trunk/krusader_kde4"

#S=${WORKDIR}/${ECVS_MODULE}

DESCRIPTION="An advanced twin-panel (commander-style) file-manager for KDE with many extras."
HOMEPAGE="http://krusader.sourceforge.net/"
#SRC_URI="mirror://sourceforge/krusader/${MY_P}.tar.gz
#	mirror://gentoo/kde-admindir-3.5.3.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~sparc x86"
IUSE="javascript kde"

DEPEND="kde? ( || ( ( kde-base/libkonq:kde-4 kde-base/kdebase-kioslaves:kde-4 )
			kde-base/kdebase:kde-4 ) )"
#	!sparc? ( javascript? ( kde-base/kjsembed:kde-4 ) )"

RDEPEND="${DEPEND}"

#need-kde 3.4

pkg_postinst() {
	echo
	elog "Krusader can use some external applications, including:"
	elog
	elog "Tools"
	elog "- eject   (sys-apps/eject)"
	elog "- locate  (sys-apps/slocate)"
	elog "- kdiff3  (kde-misc/kdiff3)"
	elog "- kompare (kde-base/kompare)"
	elog "- xxdiff  (dev-util/xxdiff)"
	elog "- krename (kde-misc/krename)"
	elog "- kmail   (kde-base/kmail)"
	elog "- kget    (kde-base/kget)"
	elog "- kdesu   (kde-base/kdesu)"
	elog
	elog "Packers"
	elog "- arj     (app-arch/arj)"
	elog "- unarj   (app-arch/unarj)"
	elog "- rar     (app-arch/rar)"
	elog "- unrar   (app-arch/unrar)"
	elog "- zip     (app-arch/zip)"
	elog "- unzip   (app-arch/unzip)"
	elog "- unace   (app-arch/unace)"
	elog "- lha     (app-arch/lha)"
	elog "- rpm     (app-arch/rpm)"
	elog "- dpkg    (app-arch/dpkg)"
	elog "- 7zip    (app-arch/p7zip)"
	elog
	elog "Checksum Tools"
	elog "- cfv     (app-arch/cfv)"
	elog "- md5deep (app-crypt/md5deep)"
	echo
}

#src_compile() {
#	local myconf="$(use_with kde konqueror) $(use_with javascript) --with-kiotar"
#	kde_src_compile
#}
