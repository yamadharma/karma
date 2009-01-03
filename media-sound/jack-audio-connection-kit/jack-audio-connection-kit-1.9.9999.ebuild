# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit subversion multilib

DESCRIPTION="Jackdmp jack implemention for multi-processor machine"
HOMEPAGE="http://www.grame.fr/~letz/jackdmp.html"
# SRC_URI="http://www.grame.fr/~letz/${MY_P}.tar.bz2"

ESVN_REPO_URI="http://subversion.jackaudio.org/jack/jack2/trunk/jackmp"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="dbus doc freebob ieee1394 monitor"

RDEPEND="dev-util/pkgconfig
	>=media-libs/alsa-lib-0.9.1
	ieee1394? ( media-libs/libffado )
	freebob? ( sys-libs/libfreebob )"
DEPEND="${RDEPEND}
	app-arch/unzip
	doc? ( app-doc/doxygen )
	dbus? ( sys-apps/dbus )"

src_configure() {
	local myconf="--prefix=/usr --destdir=${D} --libdir=/usr/$(get_libdir)"
	use dbus && myconf+=" --dbus"
	use doc && myconf+=" --doxygen"
	use monitor && myconf+=" --monitor"

	einfo "Running \"/waf configure ${myconf}\" ..."
	./waf configure ${myconf} || die "waf configure failed"
}

src_compile() {
	./waf build || die "waf build failed"
}

src_install() {
	./waf install --destdir="${D}" || die "waf install failed"
	dodoc ChangeLog README README_NETJACK2 TODO
	mv ${D}/usr/share/${PN}/* ${D}/usr/share/doc/${PF}
}
