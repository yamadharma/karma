# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils multilib distutils confutils fdo-mime versionator

MY_PV=$(replace_version_separator 2 '-')
MY_P="${PN/m/M}-${PV}"
DESCRIPTION="The free open-source video platform."
HOMEPAGE="http://www.getmiro.com/"
SRC_URI="http://ftp.osuosl.org/pub/pculture.org/miro/src/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"

IUSE="notify"

RDEPEND=">=dev-python/pygtk-2.10
	|| ( >=dev-lang/python-2.5[berkdb,sqlite]
	     >=dev-python/pysqlite-2 )
	|| ( dev-python/gnome-python
		 dev-python/gconf-python )
	>=dev-python/gtkmozembed-python-2.19.1-r11
	dev-python/dbus-python
	>=net-libs/xulrunner-1.9
	>=dev-python/pyrex-0.9.6.4
	media-gfx/imagemagick
	media-libs/xine-lib
	|| ( =net-libs/rb_libtorrent-0.13
		>=net-libs/rb_libtorrent-0.14[python] )
	dev-python/gst-python
	notify? ( dev-python/notify-python )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/pkgconfig"

S="${WORKDIR}/${MY_P}/platform/gtk-x11"


