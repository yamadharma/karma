# Copyright 1999-2006 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ECVS_SERVER="krusader.cvs.sourceforge.net:/cvsroot/krusader"
ECVS_MODULE="krusader_kde3"
ECVS_AUTH="pserver"

inherit kde cvs

S=${WORKDIR}/${ECVS_MODULE}

DESCRIPTION="Advanced twin-panel (commander-style) file-manager for KDE with many extras - cvs version"
HOMEPAGE="http://www.krusader.org/"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~sparc x86"

# kde       : Adds support for Konqueror's right-click actions and kdebase-kioslaves
# javascript: Adds experimental scripting support for the user action system
IUSE="kde javascript"
DEPEND="kde? ( || ( ( kde-base/libkonq kde-base/kdebase-kioslaves )
    kde-base/kdebase ) )
  javascript? ( kde-base/kjsembed )
  !kde-misc/krusader"
need-kde 3.4

pkg_postinst() {
	echo
	einfo "Krusader can use some external applications, including:"
	einfo
	einfo "Tools"
	einfo "- eject   (sys-apps/eject)"
  einfo "- locate  (sys-apps/slocate)"
	einfo "- kdiff3  (kde-misc/kdiff3)"
	einfo "- kompare (kde-base/kompare)"
	einfo "- xxdiff  (dev-util/xxdiff)"
	einfo "- krename (kde-misc/krename)"
	einfo "- kmail   (kde-base/kmail)"
	einfo "- kget    (kde-base/kget)"
	einfo "- kdesu   (kde-base/kdesu)"
	einfo
	einfo "Packers"
	einfo "- arj     (app-arch/arj)"
	einfo "- unarj   (app-arch/unarj)"
	einfo "- rar     (app-arch/rar)"
	einfo "- unrar   (app-arch/unrar)"
	einfo "- zip     (app-arch/zip)"
	einfo "- unzip   (app-arch/unzip)"
	einfo "- unace   (app-arch/unace)"
	einfo "- lha     (app-arch/lha)"
	einfo "- rpm     (app-arch/rpm)"
	einfo "- dpkg    (app-arch/dpkg)"
	einfo "- 7zip    (app-arch/p7zip)"
	einfo
	einfo "Checksum Tools"
	einfo "- cfv     (app-arch/cfv)"
	einfo "- md5deep (app-crypt/md5deep)"
	echo
}

src_compile() {
	local myconf="$(use_with kde konqueror) $(use_with javascript) --with-kiotar"
	kde_src_compile
}
