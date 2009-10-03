# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion flag-o-matic 

DESCRIPTION="Jackdmp jack implemention for multi-processor machine"
HOMEPAGE="http://www.grame.fr/~letz/jackdmp.html"

ESVN_REPO_URI="http://subversion.jackaudio.org/jack/jack2/trunk/jackmp"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="classic doc debug freebob dbus mixed"

RDEPEND="dev-util/pkgconfig
	>=media-libs/alsa-lib-0.9.1"
DEPEND="${RDEPEND}
	freebob? ( sys-libs/libfreebob )
	doc? ( app-doc/doxygen )
	dbus? ( sys-apps/dbus )"

pkg_setup() {
	# sandbox-1.6 breaks, on amd64 at least

	# paludis...
	if has_version "=sys-apps/sandbox-1.6" && [[ -n $(echo `ps -fp $$`|grep paludis) ]]; then
		eerror "The compile will hang with =sandbox-1.6. You are using paludis,"
		eerror "so you'll have to downgrade sandbox."
		die
	fi

	# portage
	if use amd64 && hasq "sandbox" ${FEATURES} && ! hasq "-sandbox" ${FEATURES} && has_version "=sys-apps/sandbox-1.6"; then
		eerror "The compile will hang with =sandbox-1.6. Please use:"
		echo
		eerror "FEATURES=\"-sandbox\" emerge ${PN}"
		echo
		eerror "OR downgrade sandbox to 1.4 at least."
		die
	fi
}

src_compile() {
	local myconf="--prefix=/usr --destdir=${D}"
	if use classic && use dbus ; then
	    myconf="${myconf} --classic"
	fi
	if use mixed && use amd64 ; then
	    myconf="${myconf} --mixed"
	fi
	use dbus && myconf="${myconf} --dbus"
	use debug && myconf="${myconf} -d debug"
	use doc && myconf="${myconf} --doxygen"

	einfo "Running \"./waf configure ${myconf}\" ..."
	./waf configure ${myconf} || die "waf configure failed"
	./waf build ${MAKEOPTS} || die "waf build failed"
}

src_install() {
	./waf --destdir="${D}" install || die "waf install failed"
}
