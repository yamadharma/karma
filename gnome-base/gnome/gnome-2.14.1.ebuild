# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome/gnome-2.14.1.ebuild,v 1.2 2006/05/16 04:46:30 dertobi123 Exp $

DESCRIPTION="Meta package for the GNOME desktop"
HOMEPAGE="http://www.gnome.org/"

LICENSE="as-is"
SLOT="2.0"

# things that were not ready for this meta.
# make a new revision when they are ready.
# evince-0.5.2
# gst-plugins-base-0.10.5

# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="amd64 ~hppa ~ppc ~ppc64 ~sparc x86"

IUSE="accessibility cdr dvdr hal"

S=${WORKDIR}

RDEPEND="!gnome-base/gnome-core

	>=dev-libs/glib-2.10.2
	>=x11-libs/gtk+-2.8.17
	>=dev-libs/atk-1.11.4
	>=x11-libs/pango-1.12.1

	>=dev-libs/libxml2-2.6.23
	>=dev-libs/libxslt-1.1.15

	>=media-libs/audiofile-0.2.6-r1
	>=media-sound/esound-0.2.36
	>=x11-libs/libxklavier-2.2
	>=media-libs/libart_lgpl-2.3.17

	>=dev-libs/libIDL-0.8.6
	>=gnome-base/orbit-2.14.0

	>=x11-libs/libwnck-2.14.1
	>=x11-wm/metacity-2.14.2

	>=gnome-base/gnome-keyring-0.4.9
	>=gnome-extra/gnome-keyring-manager-2.14.0

	>=gnome-base/gnome-vfs-2.14.0

	>=gnome-base/gnome-mime-data-2.4.2

	>=gnome-base/gconf-2.14.0
	>=net-libs/libsoup-2.2.92

	>=gnome-base/libbonobo-2.14.0
	>=gnome-base/libbonoboui-2.14.0
	>=gnome-base/libgnome-2.14.1
	>=gnome-base/libgnomeui-2.14.1
	>=gnome-base/libgnomecanvas-2.14.0
	>=gnome-base/libglade-2.5.1

	>=gnome-extra/bug-buddy-2.14.0
	>=gnome-base/control-center-2.14.1

	>=gnome-base/eel-2.14.1
	>=gnome-base/nautilus-2.14.1

	>=media-libs/gstreamer-0.10.4
	>=media-libs/gst-plugins-base-0.10.4-r1
	>=media-libs/gst-plugins-good-0.10.2
	>=gnome-extra/gnome-media-2.14.0
	>=media-sound/sound-juicer-2.14.2
	>=media-video/totem-1.4.0

	>=media-gfx/eog-2.14.1

	>=www-client/epiphany-2.14.1
	>=app-arch/file-roller-2.14.1
	>=gnome-extra/gcalctool-5.7.32

	>=gnome-extra/gconf-editor-2.14.0
	>=gnome-base/gdm-2.14.0
	>=x11-libs/gtksourceview-1.6.1
	>=app-editors/gedit-2.14.2

	>=app-text/evince-0.5.2

	>=gnome-base/gnome-desktop-2.14.1.1
	>=gnome-base/gnome-session-2.14.1
	>=gnome-base/gnome-applets-2.14.1
	>=gnome-base/gnome-panel-2.14.1
	>=gnome-base/gnome-menus-2.13.5
	>=x11-themes/gnome-icon-theme-2.14.2
	>=x11-themes/gnome-themes-2.14.0
	>=gnome-extra/deskbar-applet-2.14.1.1

	>=x11-themes/gtk-engines-2.6.8
	>=x11-themes/gnome-backgrounds-2.14.0

	>=x11-libs/vte-0.12.0
	>=x11-terms/gnome-terminal-2.14.1

	>=gnome-extra/gucharmap-1.6.0
	>=gnome-base/libgnomeprint-2.12.1
	>=gnome-base/libgnomeprintui-2.12.1

	>=gnome-extra/gnome-utils-2.14.0

	>=gnome-extra/gnome-games-2.14.1
	>=gnome-base/librsvg-2.14.3

	>=gnome-extra/gnome-system-monitor-2.14.1
	>=gnome-base/libgtop-2.14.1

	>=x11-libs/startup-notification-0.8

	>=gnome-extra/gnome2-user-docs-2.14.0
	>=gnome-extra/yelp-2.14.1
	>=gnome-extra/zenity-2.14.1

	>=net-analyzer/gnome-netstatus-2.12.0
	>=net-analyzer/gnome-nettool-2.14.1

	cdr? ( >=gnome-extra/nautilus-cd-burner-2.14.1 )
	dvdr? ( >=gnome-extra/nautilus-cd-burner-2.14.1 )

	hal? ( >=gnome-base/gnome-volume-manager-1.5.15 )

	>=gnome-extra/gtkhtml-3.10.1
	>=mail-client/evolution-2.6.1
	>=gnome-extra/evolution-data-server-1.6.1
	>=gnome-extra/evolution-webcal-2.5.90

	>=net-misc/vino-2.13.5

	>=app-admin/gnome-system-tools-2.14.0
	>=app-admin/system-tools-backends-1.4.2
	>=gnome-extra/fast-user-switch-applet-2.14.1

	accessibility? (
		>=gnome-extra/libgail-gnome-1.1.3
		>=gnome-base/gail-1.8.11
		>=gnome-extra/at-spi-1.7.7-r1
		>=app-accessibility/dasher-4.0.2
		>=app-accessibility/gnome-mag-0.12.4
		>=app-accessibility/gnome-speech-0.3.10
		>=app-accessibility/gok-1.0.7
		>=app-accessibility/gnopernicus-1.0.4 )"

# Development tools
#   scrollkeeper
#   pkgconfig
#   intltool
#   gtk-doc
#   gnome-doc-utils


pkg_postinst() {

	einfo "Note that to change windowmanager to metacity do: "
	einfo " export WINDOW_MANAGER=\"/usr/bin/metacity\""
	einfo "of course this works for all other window managers as well"
	einfo
	einfo "To take full advantage of GNOME's functionality, please emerge"
	einfo "gamin, a File Alteration Monitor."
	einfo "Make sure you have inotify enabled in your kernel ( >=2.6.13 )"
	einfo
	einfo "Make sure you rc-update del famd and emerge unmerge fam if you"
	einfo "are switching from fam to gamin."
	einfo
	einfo "If you have problems, you may want to try using fam instead."
	einfo
	einfo
	einfo "Add yourself to the plugdev group if you want"
	einfo "automounting to work."
	einfo
}
