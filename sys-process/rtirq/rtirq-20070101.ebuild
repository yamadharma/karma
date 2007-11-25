# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

RESTRICT="nomirror"
inherit eutils 
DESCRIPTION="Change the realtime scheduling policy and priority of relevant system driver IRQ handlers"
HOMEPAGE="http://www.rncbc.org/jack/"

P_URL="http://www.rncbc.org/jack"
SRC_URI="http://download.tuxfamily.org/proaudio/distfiles/${P}.tar.gz"
LICENSE="GPL"
SLOT="0"
KEYWORDS="x86 amd64 ppc"
IUSE=""

DEPEND="|| ( >=sys-apps/util-linux-2.13 sys-process/schedutils )
		sys-apps/sysvinit"

src_unpack(){
	unpack "${A}"
	cd ${S}
	gzip -cdf "${FILESDIR}/rt-initscript.gz" >  rtirq
	sed -ie "s:^\(RTIRQ_CONFIG\=\)\(.*\):\1/etc/conf.d/rtirq:" rtirq.sh || die "patching failed"
	sed -ie "s/:-\"softirq-timer\"//" rtirq.sh || die "patching failed"
	sed -ie "s:/etc/sysconfig/rtirq:/etc/conf.d/rtirq:" rtirq.conf
}

src_install(){
	exeinto /etc/init.d
	doexe rtirq rtirq.sh 
	insinto /etc/conf.d
	newins rtirq.conf rtirq
}

pkg_postinst(){
	einfo "now add the script to your runlevel"
	einfo "e.g. rc-update add rtirq default"
	einfo "config-file: /etc/conf.d/rtirq"

	einfo "You need an realtime-kernel to use this init-script:"
	einfo "kernel-patch: redhat.com/~mingo/realtime-preempt"
	einfo "select: (X) Complete Preemption (Real-Time) in kernel-config."
	einfo "Easy way to get an realtime kernel try:"
	einfo "emerge rt-sources from the proaudio overlay"
}
