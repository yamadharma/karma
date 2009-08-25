# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header:

EAPI="1"

inherit gnome2 flag-o-matic subversion autotools

DESCRIPTION="A full featured, dual-pane file manager for Gnome2"
HOMEPAGE="http://www.nongnu.org/gcmd/"

ESVN_REPO_URI="svn://svn.gnome.org/svn/gnome-commander/branches/gcmd-1-3"
SRC_URI=""

KEYWORDS=""

LICENSE="GPL-2"

IUSE="doc chm exif gsf taglib python"
SLOT="0"

USE_DESC="chm: add support for Microsoft Compiled HTML Help files
		  exif: add support for Exif and IPTC
		  gsf: add support for OLE, OLE2 and ODF
		  taglib: add support for ID3, Vorbis, FLAC and APE
		  python: add support for python plugins"

RDEPEND=">=x11-libs/gtk+-2.8.0:2
		 >=dev-libs/glib-2.6.0:2
		 >=gnome-base/libgnomeui-2.4.0
		 >=gnome-base/libgnome-2.4.0
		 >=gnome-base/gnome-vfs-2.0.0
		 virtual/fam
		 chm?    ( >=dev-libs/chmlib-0.39      )
		 exif?   ( >=media-gfx/exiv2-0.14      )
		 gsf?    ( >=gnome-extra/libgsf-1.12.0 )
		 taglib? ( >=media-libs/taglib-1.4     )
		 python? ( >=dev-lang/python-2.4       )"

DEPEND="${RDEPEND}
		gnome-base/gnome-common
		dev-util/intltool
		dev-util/pkgconfig"

DOCS="AUTHORS BUGS ChangeLog NEWS README TODO"

pkg_setup() {
	G2CONF=" ${G2CONF}
			 $(use_with   chm    chmlib)
			 $(use_with   exif   exiv2 )
			 $(use_with   gsf    libgsf)
			 $(use_with   taglib taglib)
			 $(use_enable python python)"

	filter-ldflags -Wl,--as-needed
}

src_unpack() {
	subversion_fetch || die "svn fetch failed"

	cd "${S}"

	gnome2_omf_fix || die "Gnome2 OMF Fix failed"

	# implement autogen.sh with eclass tools
	rm -rf autom4te.cache
	autotools_run_tool libtoolize --force --copy
	autotools_run_tool glib-gettextize --force --copy
	autotools_run_tool intltoolize --force --copy --automake
	autotools_run_tool gnome-doc-common --copy
	autotools_run_tool gnome-doc-prepare --force --copy
	eaclocal
	eautoconf
	eautoheader
	eautomake --force

	elibtoolize ${ELTCONF} || die "elibtoolize failed"
}
