# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs
RESTRICT="nomirror"
DESCRIPTION="watchdog to ensure a realtime process won't hang the machine"
HOMEPAGE="http://www.notam02.no/~kjetism/src/"
SRC_URI="http://www.notam02.no/~kjetism/src/${P}.tar"

LICENSE="GPL2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=">=gnome-base/libgtop-2.0
		|| ( x11-base/xorg-x11 x11-apps/xmessage )"
RDEPEND=""

src_compile(){
	#CONFIG="-O2 `pkg-config --libs --cflags libgtop-2.0` -Wall -lpthread -DWHICH_WISH=\"`which xmessage`\""
	#$(tc-getCC ) ${CFLAGS} das_watchdog.c -o  ${PN} ${CONFIG} || die "compile failed"
	emake || die
	gzip -d -c ${FILESDIR}/das_watchdog-init.d.gz > das_watchdog-init.d || die "excracing rc-script"
}

src_install(){
	dosbin ${PN}
	dobin test_rt
	dodoc README
	newinitd ${S}/das_watchdog-init.d ${PN}
}

pkg_postinst(){
	einfo "now add the script to your runlevel"
	einfo "e.g. rc-update add ${PN} default"
	einfo "and maybe you also want to use a realtime-kernel:"
	einfo "\"emerge rt-sources\" or fetch the the"
	einfo "kernel-patch: redhat.com/~mingo/realtime-preempt/"
}
