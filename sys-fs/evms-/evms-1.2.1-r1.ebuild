# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/sys-fs/evms/evms-1.2.1-r1.ebuild,v 1.1 2003/09/15 17:46:24 seemant Exp $

IUSE="ncurses gtk"

inherit eutils

S="${WORKDIR}/${P}"
DESCRIPTION="Utilities for the IBM Enterprise Volume Management System"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.sourceforge.net/projects/evms"

KEYWORDS="x86 amd64 ~ppc"
LICENSE="GPL-2"
SLOT="0"

#EVMS uses libuuid from e2fsprogs
DEPEND="virtual/glibc
	sys-fs/e2fsprogs
	gtk? ( =x11-libs/gtk+-1* )
	ncurses? ( sys-libs/ncurses )"


src_compile() {
	local interfaces="CommandLine,utilities,LvmUtils"
	use ncurses && interfaces="ncurses,${interfaces}"
	use gtk && interfaces="evmsgui,${interfaces}"

	cd engine
	./configure \
		--prefix=/usr \
		--libdir=/lib \
		--sbindir=/sbin \
		--with-plugins=all \
		--mandir=/usr/share/man \
		--includedir=/usr/include \
		--with-interfaces=${interfaces} \
		--host=${CHOST} || die "bad ./configure"
	#1.2.0 doesn't support parallel make
	make || die "compile problem"
}

src_install() {
	make -C engine DESTDIR=${D} install || die
	dodoc CHANGES COPYING EVMS*.txt PLUGIN.IDS

	# move static libraries to /usr/lib
	dodir /usr/lib
	mv -f ${D}/lib/*.a ${D}/usr/lib
	# Create linker scripts for dynamic libs in /lib, else gcc
	# links to the static ones in /usr/lib first.  Bug #4411.
	for x in ${D}/usr/lib/*.a
	do
		if [ -f ${x} ]
		then
			local lib="${x##*/}"
			gen_usr_ldscript ${lib/\.a/\.so}
		fi
	done

	# realize these symlinks now so they get included
	cd ${D}/lib
	rm -f libdlist.so libevms.so
	ln -sf libevms-${PV}.so libevms.so.1
	ln -sf libevms.so.1 libevms.so
	ln -sf libdlist-1.0.so libdlist.so.1
	ln -sf libdlist.so.1 libdlist.so

	# the gtk+ frontend should live in /usr/sbin
	if [ -n "`use gtk`" ]
	then
		dodir /usr/sbin
		mv -f ${D}/sbin/evmsgui ${D}/usr/sbin
	fi

	exeinto /etc/init.d
	newexe ${FILESDIR}/evms-init evms
}

