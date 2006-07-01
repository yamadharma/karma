# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# ECVS_CVS_COMMAND="cvs -q"
ECVS_SERVER="cvs.sourceforge.net:/cvsroot/sim-icq"
ECVS_USER="anonymous"
# ECVS_AUTH="no"
ECVS_MODULE="sim"
# ECVS_CO_OPTS="-P -D ${PV/*_pre}"
# ECVS_UP_OPTS="-dP -D ${PV/*_pre}"
ECVS_TOP_DIR="${DISTDIR}/cvs-src/sourceforge.net-sim"

inherit eutils kde-functions cvs

S=${WORKDIR}/${ECVS_MODULE}

DESCRIPTION="An ICQ v8 Client. Supports File Transfer, Chat, Server-Side Contactlist."
HOMEPAGE="http://sim-icq.sourceforge.net"
# SRC_URI="mirror://sourceforge/sim-icq/${P}-2.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="x86 ~ppc amd64"
IUSE="ssl kde debug"

RDEPEND="x11-libs/qt
	kde? ( || ( kde-base/kdebase-data kde-base/kdebase ) )
	ssl? ( dev-libs/openssl )
	dev-libs/libxslt"
# kdebase-data provides the icon "licq.png"

DEPEND="${RDEPEND}
	sys-devel/flex
	=sys-devel/automake-1.7*
	=sys-devel/autoconf-2.5*"

src_compile() {
#	epatch ${FILESDIR}/sim-0.9.4-gcc34.diff
#	epatch ${FILESDIR}/sim-0.9.4-alt-histpreview-apply-fix.diff
	export WANT_AUTOCONF=2.5
	export WANT_AUTOMAKE=1.7

	set-qtdir 3
	set-kdedir 3

	make -f admin/Makefile.common

	econf `use_enable ssl openssl` \
		`use_enable kde` \
		`use_enable debug` || die "econf failed"

	make clean  || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc TODO README ChangeLog AUTHORS
}
