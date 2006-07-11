# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils cvs

DESCRIPTION="A set of libraries and utilities for reading Microsoft Access database (MDB) files"
HOMEPAGE="http://sourceforge.net/projects/mdbtools/"
ECVS_SERVER="$PN.cvs.sourceforge.net:/cvsroot/$PN"
ECVS_MODULE="$PN"
MY_PV_DATE="${PV#*_pre}"
ECVS_CO_OPTS="-D ${MY_PV_DATE}"
ECVS_UP_OPTS="-dP ${ECVS_CO_OPTS}"
S="$WORKDIR/$PN"

IUSE="odbc X"
LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="x86 amd64"

DEPEND=">=dev-libs/glib-2
	sys-libs/ncurses
	sys-libs/readline
	>=sys-devel/flex-2.5.0
	>=sys-devel/bison-1.35
	X? ( >=x11-libs/gtk+-2
		>=gnome-base/libglade-2
		>=gnome-base/libgnomeui-2 )
	odbc? ( >=dev-db/unixODBC-2.0 )"

src_unpack() {
	cvs_src_unpack
	cd ${S}
	./autogen.sh || die "autogen failed"
	touch src/sql/parser.y || die "touch failed"
}

src_compile() {
	local myconf
	use odbc && myconf="${myconf} --with-unixodbc=/usr"

	econf --enable-sql \
		${myconf} || die "configure failed"

	emake || die

	for x in include/mdb*.h; do
		sed -e '/^#include <config.h>/{rinclude/config.h
d}' -i $x
	done
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc COPYING* NEWS README* TODO AUTHORS HACKING ChangeLog

	# add a compat symlink
	dosym /usr/bin/gmdb2 /usr/bin/gmdb
}
