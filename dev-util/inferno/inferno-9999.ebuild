# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils subversion flag-o-matic multilib

ESVN_REPO_URI="http://inferno-os.googlecode.com/svn/trunk/"

DESCRIPTION="Inferno Distributed Operating System"
HOMEPAGE="http://www.vitanuova.com/inferno/index.html
	http://code.google.com/p/inferno-os/"
# SRC_URI=""

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64"

IUSE="X"

DEPEND="virtual/libc"
RDEPEND="${DEPEND}"

INFERNO_ROOT=/usr/inferno


src_prepare() {
	sed -i -e "s:^ROOT=.*:ROOT=${S}:g" \
		-e "s:^SYSHOST=.*:SYSHOST=Linux:g" \
		-e "s:^OBJTYPE=.*:OBJTYPE=386:g" \
    		mkconfig

}

src_compile() {
	strip-flags
	use amd64 && multilib_toolchain_setup x86

	. ./makemk.sh || die "building mk failed"
	${S}/Linux/386/bin/mk all || die "compile failed"
}

src_install () 
{
	dodir ${PLAN9_DEST}
	cp -R ${S}/* ${D}/${PLAN9_DEST}
	
	dosym ${PLAN9_DEST}/bin/9 /usr/bin/9

	tar xjvf ${DISTDIR}/pgw.tar.bz2 -C ${D}/${PLAN9_DEST}/dict
	tar xjvf ${DISTDIR}/roget.tar.bz2 -C ${D}/${PLAN9_DEST}/dict

	tar xzvf ${DISTDIR}/scat.tgz -C ${D}/${PLAN9_DEST}/sky
	cp ${D}/${PLAN9_DEST}/sky/here.sample ${D}/${PLAN9_DEST}/sky/here
	
	rm -rf ${D}/${PLAN9_DEST}/dist
	rm -rf ${D}/${PLAN9_DEST}/src
	rm -rf ${D}/${PLAN9_DEST}/unix
	rm -rf ${D}/${PLAN9_DEST}/9pm
	
	cd ${D}/${PLAN9_DEST}
	rm -f install* CHANGES INSTALL LICENSE Makefile README TODO config*
	cd ${S}

	chgrp kmem ${D}/${PLAN9_DEST}/bin/auxstats
	chmod +s ${D}/${PLAN9_DEST}/bin/auxstats
	
	# mail
	cd ${D}/${PLAN9_DEST}/log 
	chmod 666 smtp smtp.debug smtp.fail mail >smtp >smtp.debug >smtp.fail >mail
	chmod 777 ${D}/${PLAN9_DEST}/mail/queue
	cd ${S}

	doenvd ${FILESDIR}/99plan9port
	dosed -i -e "s:@PLAN9_DEST@:$PLAN9_DEST:g" /etc/env.d/99plan9port

	exeinto /etc/X11/xinit/xinitrc.d
	doexe ${FILESDIR}/99-plan9serve
	dosed -i -e "s:@PLAN9_DEST@:$PLAN9_DEST:g" /etc/X11/xinit/xinitrc.d/99-plan9serve
		
	exeinto /etc/X11/Sessions/
	doexe ${FILESDIR}/rio 
	dosed -i -e "s:@PLAN9_DEST@:$PLAN9_DEST:g" /etc/X11/Sessions/rio
	
	insinto /usr/share/xsessions
	doins ${FILESDIR}/rio.desktop
	
	dodoc CHANGES LICENSE README TODO install.txt
}

pkg_postinst ()
{
	env-update
}