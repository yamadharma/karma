# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/media-sound/alsa-driver/alsa-driver-0.9.7-r1.ebuild,v 1.1 2003/10/02 03:33:07 agenkin Exp $

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
KEYWORDS="~x86 ~ppc"

ALSA_REVISION="c"
SRC_URI="mirror://alsaproject/driver/${P}${ALSA_REVISION}.tar.bz2"
S=${WORKDIR}/${P}${ALSA_REVISION}

src_unpack() {
	unpack ${A}
	cd ${S}
	# The makefile still installs an alsasound initscript,
	# which we REALLY dont want.
	# This patch stops that
	epatch ${FILESDIR}/makefile.patch

	# Looks like the below are not needed as of 0.9.7.
	#epatch ${FILESDIR}/wolk.patch
	#epatch ${FILESDIR}/alsa-compile-fix
}


src_compile() {
	# Portage should determine the version of the kernel sources
	check_KV

	myconf=""
	use oss && myconf="$myconf --with-oss=yes" || \
		myconf="$myconf --with-oss=no"

	./configure \
		$myconf \
		--host=${CHOST} \
		--prefix=/usr \
		--with-kernel="${ROOT}usr/src/linux" \
		--with-moddir=/lib/modules/${KV}/sound \
		--with-isapnp=yes \
		--with-sequencer=yes \
		--with-cards="${ALSA_CARDS}" \
		|| die "./configure failed"

	
	# Wolk-kernel hack
	sed -i -e "s:/\* #undef CONFIG_HAVE_PDE \*/:#define CONFIG_HAVE_PDE 1:" include/config.h
	
	emake  || die "Parallel Make Failed"
	#CFLAGS="${CFLAGS} -DCONFIG_HAVE_PDE"
}


src_install() {
	dodir /usr/include/sound
	make DESTDIR=${D} install || die

	dodoc CARDS-STATUS COPYING FAQ INSTALL README WARNING TODO doc/*
}

pkg_postinst() {
	if [ "${ROOT}" = / ]
	then
		[ -x /usr/sbin/update-modules ] && /usr/sbin/update-modules
	fi

	einfo
	einfo "The alsasound initscript and modules.d/alsa have now moved to alsa-utils"
	einfo
	einfo "Also, remember that all mixer channels will be MUTED by default."
	einfo "Use the 'alsamixer' program to unmute them."
	einfo
}

