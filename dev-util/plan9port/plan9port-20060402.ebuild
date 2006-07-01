# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

IUSE=""

DESCRIPTION="Port of the bulk of the Plan9 software build environment to Unix"
HOMEPAGE="http://swtch.com/plan9port"
SRC_URI="ftp://quenix2.dyndns.org/FreeBSD/ports/distfiles/${P}.tgz
	http://pdos.lcs.mit.edu/~rsc/scat.tgz
	http://pdos.lcs.mit.edu/~rsc/software/plan9/pgw.tar.bz2
	http://pdos.lcs.mit.edu/~rsc/software/plan9/roget.tar.bz2"

S=${WORKDIR}/plan9

SLOT="0"
LICENSE="LucentPL-1.02"
KEYWORDS="x86 sparc alpha ia64 s390 ppc amd64"

DEPEND="virtual/libc"
RDEPEND="virtual/libc"

PLAN9_DEST=/usr/plan9

src_unpack ()
{
	unpack ${P}.tgz

	cd ${S}
	find . -name CVS -exec rm -rf {} \; 2> /dev/null
	find . -name .cvsignore -exec rm {} \; 2> /dev/null
	
	sed -i -e "s:^new=.*:new=$PLAN9_DEST:g" lib/moveplan9.sh
}

src_compile () 
{
	./INSTALL
}

src_install () 
{
	dodir ${PLAN9_DEST}
	cp -R ${S}/* ${D}/${PLAN9_DEST}

	tar xjvf ${DISTDIR}/pgw.tar.bz2 -C ${D}/${PLAN9_DEST}/dict
	tar xjvf ${DISTDIR}/roget.tar.bz2 -C ${D}/${PLAN9_DEST}/dict

	tar xzvf ${DISTDIR}/scat.tgz -C ${D}/${PLAN9_DEST}/sky
	cp ${D}/${PLAN9_DEST}/sky/here.sample ${D}/${PLAN9_DEST}/sky/here
	
	rm -rf ${D}/${PLAN9_DEST}/log
	rm -rf ${D}/${PLAN9_DEST}/dist
	rm -rf ${D}/${PLAN9_DEST}/src

	chgrp kmem ${D}/${PLAN9_DEST}/bin/auxstats
	chmod +s ${D}/${PLAN9_DEST}/bin/auxstats
	
	doenvd ${FILESDIR}/99plan9port
	dosed -i -e "s:@PLAN9_DEST@:$PLAN9_DEST:g" /etc/env.d/99plan9port
	
	exeinto /etc/X11/Sessions/
	doexe ${FILESDIR}/rio 
	dosed -i -e "s:@PLAN9_DEST@:$PLAN9_DEST:g" /etc/X11/Sessions/rio
	
	dodoc CHANGES LICENSE README TODO install.txt
}

pkg_postinst ()
{
	env-update
}