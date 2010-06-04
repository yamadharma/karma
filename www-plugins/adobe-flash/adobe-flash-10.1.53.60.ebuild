# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-plugins/adobe-flash/adobe-flash-10.0.45.2.ebuild,v 1.3 2010/03/04 14:11:50 pacho Exp $

EAPI=1

inherit nsplugins rpm multilib toolchain-funcs

MY_URI="http://download.macromedia.com/pub/labs/flashplayer10"

DESCRIPTION="Adobe Flash Player"
SRC_URI="!debug? ( ${MY_URI}/flashplayer10_1_rc6_linux_052510.tar.gz )
	debug? ( ${MY_URI}/flashplayer10_1_rc6_debug_linux_052510.tar.gz )"
HOMEPAGE="http://www.adobe.com/"
IUSE="debug"
SLOT="0"

KEYWORDS="-* ~x86"
LICENSE="AdobeFlash-10"
RESTRICT="strip mirror"

S=${WORKDIR}

NATIVE_DEPS="x11-libs/gtk+:2
	media-libs/fontconfig
	dev-libs/nss
	net-misc/curl
	>=sys-libs/glibc-2.4
	|| ( media-fonts/freefont-ttf media-fonts/corefonts )"

EMUL_DEPS="app-emulation/emul-linux-x86-baselibs
	app-emulation/emul-linux-x86-gtklibs
	app-emulation/emul-linux-x86-soundlibs
	app-emulation/emul-linux-x86-xlibs"

RDEPEND="$NATIVE_DEPS
	!www-plugins/libflashsupport"

# Our new flash-libcompat suffers from the same EXESTACK problem as libcrypto
# from app-text/acroread, so tell QA to ignore it.
# Apparently the flash library itself also suffers from this issue
QA_EXECSTACK="opt/flash-libcompat/libcrypto.so.0.9.7
	opt/netscape/plugins32/libflashplayer.so
	opt/netscape/plugins/libflashplayer.so"

QA_DT_HASH="opt/flash-libcompat/lib.*
	opt/netscape/plugins32/libflashplayer.so
	opt/netscape/plugins/libflashplayer.so"

pkg_setup() {
	export native_install=1
}

src_install() {
	if [[ $native_install ]]; then
		exeinto /opt/netscape/plugins
		doexe libflashplayer.so
		inst_plugin /opt/netscape/plugins/libflashplayer.so
	fi

	if [[ $need_lahf_wrapper ]]; then
		# This experimental wrapper, from Maks Verver via bug #268336 should
		# emulate the missing lahf instruction affected platforms.
		exeinto /opt/netscape/plugins
		doexe flashplugin-lahf-fix.so
		inst_plugin /opt/netscape/plugins/flashplugin-lahf-fix.so
	fi
}

pkg_postinst() {
	ewarn "Flash player is closed-source, with a long history of security"
	ewarn "issues.  Please consider only running flash applets you know to"
	ewarn "be safe.  The 'flashblock' extension may help for mozilla users:"
	ewarn "  https://addons.mozilla.org/en-US/firefox/addon/433"
}
