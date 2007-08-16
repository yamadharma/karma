# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Modified for SVN by Sebastian Schuberth <sschuberth_AT_gmail_DOT_com>
# $Header: $

inherit gnome2 eutils subversion

ESVN_OPTIONS="-r{${PV/*_pre}}"
ESVN_REPO_URI="https://ogmrip.svn.sourceforge.net/svnroot/ogmrip/trunk/ogmrip/"
ESVN_PROJECT="ogmrip"
ESVN_BOOTSTRAP="NOCONFIGURE=1 ./autogen.sh"

DESCRIPTION="Graphical frontend and libraries for ripping DVDs and encoding to AVI/OGM/MKV/MP4"
HOMEPAGE="http://ogmrip.sourceforge.net/"
SRC_URI=""
LICENSE="LGPL-2.1"
SLOT="0"
IUSE="aac debug doc dts gtk hal libnotify matroska spell srt theora x264"
KEYWORDS="amd64 ~ppc ~ppc64 x86"

DEPEND=">=app-i18n/enca-1.0
       >=dev-libs/glib-2.6
       >=dev-libs/libxml2-2
       >=dev-util/gtk-doc-1.4-r1
       >=dev-util/intltool-0.29
       >=dev-util/pkgconfig-0.12.0
       >=gnome-base/gconf-2.6
       >=media-libs/libdvdread-0.9.7
       >=media-sound/lame-3.96
       >=media-sound/ogmtools-1.4
       >=media-sound/vorbis-tools-1.0
       >=media-video/mplayer-1.0_pre4
       >=sys-apps/eject-2.1.5-r1
       aac? ( >=media-libs/faac-1.24 )
       gtk? ( >=x11-libs/gtk+-2.6
               >=gnome-base/libglade-2.5 )
       hal? ( >=sys-apps/hal-0.4.2 )
       libnotify? ( >=x11-libs/libnotify-0.4.3 )
       matroska? ( >=media-video/mkvtoolnix-0.9 )
       spell? ( >=app-text/enchant-1.1 )
       srt? ( >=app-text/gocr-0.39 )
       theora? ( >=media-libs/libtheora-1.0_alpha6 )"

DOCS="AUTHORS ChangeLog README NEWS TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable aac aac-support)
		$(use_enable debug maintainer-mode)
		$(use_enable gtk gtk-support)
		$(use_enable hal hal-support)
		$(use_enable libnotify libnotify-support)
		$(use_enable matroska matroska-support)
		$(use_enable spell enchant-support)
		$(use_enable srt srt-support)
		$(use_enable theora theora-support)"

	if ! built_with_use -a media-video/mplayer dvd encode xvid; then
		eerror "Please check that your USE flags contain 'dvd', 'encode', 'xvid'"
		eerror "and emerge mplayer again."
		MISSING_MPLAYER_USE_FLAG=1
	fi
	if use dts && ! built_with_use -a media-video/mplayer dts; then
		eerror "Please check that your USE flags contain 'dts'"
		eerror "and emerge mplayer again."
		MISSING_MPLAYER_USE_FLAG=1
	fi
	if use x264 && ! built_with_use -a media-video/mplayer x264; then
		eerror "Please check that your USE flags contain 'x264'"
		eerror "and emerge mplayer again."
		MISSING_MPLAYER_USE_FLAG=1
	fi
	if [ ${MISSING_MPLAYER_USE_FLAG} ]; then
		die "MPlayer is missing required USE flags (see above for details)."
	fi
}
