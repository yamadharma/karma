# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/media-sound/alsa-driver/alsa-driver-1.0.2c.ebuild,v 1.2 2004/02/15 08:22:08 eradicator Exp $

DESCRIPTION="Advanced Linux Sound Architecture kernel modules"
HOMEPAGE="http://www.alsa-project.org/"
LICENSE="GPL-2 LGPL-2.1"

# By default, drivers for all supported cards will be compiled.
# If you want to only compile for specific card(s), set ALSA_CARDS
# environment to a space-separated list of drivers that you want to build.
# For example:
#
#   env ALSA_CARDS='emu10k1 intel8x0 ens1370' emerge alsa-driver
#
[ x"${ALSA_CARDS}" = x ] && ALSA_CARDS=all

IUSE="oss"

# Need the baselayout 1.7.9 or newer for the init script to work correctly.
DEPEND="sys-devel/autoconf
	virtual/glibc
	virtual/linux-sources
	>=sys-apps/portage-1.9.10
	>=sys-apps/baselayout-1.7.9"
PROVIDE="virtual/alsa"

SLOT="0.9"
KEYWORDS="x86 ~ppc -sparc ~amd64 ~alpha ~ia64"

#MY_P=${P/_rc/rc}
MY_PN=alsa-driver
MY_PV=${PV}
MY_P=${MY_PN}-${MY_PV}
#SRC_URI="ftp://ftp.alsa-project.org/pub/driver/${MY_P}.tar.bz2"
SRC_URI="mirror://alsaproject/driver/${MY_P}.tar.bz2"
RESTRICT="nomirror"
S=${WORKDIR}/${MY_P}

src_unpack () 
{
	unpack ${A}
	cd ${S}
	# The makefile still installs an alsasound initscript,
	# which we REALLY dont want.
	# This patch stops that
	epatch ${FILESDIR}/makefile.patch || die "Makefile patch failed"
	epatch ${FILESDIR}/${MY_PN}-0.9.8-au-fix.patch
}


src_compile () 
{
	./configure \
		$myconf \
		--host=${CHOST} \
		--prefix=/usr \
		--with-kernel="${ROOT}usr/src/linux" \
		--with-isapnp=yes \
		--with-sequencer=yes \
		|| die "./configure failed"
}


src_install() {
	dodir /usr/include/sound
	make DESTDIR=${D} install-headers || die

	rm doc/Makefile
	dodoc CARDS-STATUS COPYING FAQ INSTALL README WARNING TODO doc/*
}
