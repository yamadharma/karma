# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

GTK_SHARP_REQUIRED_VERSION="2.12"

inherit gtk-sharp-module

SLOT="2"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="${DEPEND}
	>=dev-dotnet/glade-sharp-2.12
	>=gnome-base/gnome-vfs-2.20
	dev-util/pkgconfig"
