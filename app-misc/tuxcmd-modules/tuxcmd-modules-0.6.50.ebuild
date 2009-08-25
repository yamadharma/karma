# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Tux Commander - Fast and Small filemanager - VFS modules"
HOMEPAGE="http://tuxcmd.sourceforge.net/"
SRC_URI="mirror://sourceforge/tuxcmd/tuxcmd-modules-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64" # FreePascal restrictions
IUSE="gnome zip unrar libarchive"

DEPEND=""
RDEPEND=">=app-misc/tuxcmd-0.6.50
	 >=dev-libs/glib-2.16.0
	 gnome? ( >=gnome-base/gvfs-0.2.5 )
	 libarchive? ( >=app-arch/libarchive-2.5.5 )"


src_compile() {
        cd "${WORKDIR}/tuxcmd-modules-${PV}"
	
	if use gnome; then
	    einfo "Making GVFS module"
	    ( cd gvfs && emake -j1 || die "compilation failed" )
	fi

	if use zip; then
	    einfo "Making ZIP module"
	    ( cd zip && emake -j1 || die "compilation failed" )
	fi

	if use unrar; then
	    einfo "Making UNRAR module"
	    ( cd unrar && emake -j1 || die "compilation failed" )
	fi

	if use libarchive; then
	    einfo "Making LIBARCHIVE module"
	    ( cd libarchive && emake -j1 shared || die "compilation failed" )
	fi
}

src_install() {
	case ${ARCH} in
        x86)    LIBDIR="lib" ;;
        amd64)  LIBDIR="lib64" ;;
        *)      die "This ebuild doesn't support ${ARCH}." ;;
        esac
	
	dodir "/usr/${LIBDIR}/tuxcmd"

	
        cd "${WORKDIR}/tuxcmd-modules-${PV}"
	if use gnome; then
	    ( cd gvfs && emake DESTDIR="${D}/usr" install || die "emake install failed" )
	fi

	if use zip; then
	    ( cd zip && emake DESTDIR="${D}/usr" install || die "emake install failed" )
	fi

	if use unrar; then
	    ( cd unrar && emake DESTDIR="${D}/usr" install || die "emake install failed" )
	fi

	if use libarchive; then
	    ( cd libarchive && emake DESTDIR="${D}/usr" install || die "emake install failed" )
	fi
}

