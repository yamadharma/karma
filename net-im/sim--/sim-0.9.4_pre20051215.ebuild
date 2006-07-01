# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


inherit subversion eutils kde-functions

ESVN_REPO_URI="svn://svn.berlios.de/sim-im/trunk/sim"
ESVN_STORE_DIR="${DISTDIR}/svn-src/berlios.de/sim"


DESCRIPTION="Sim instant Messanger (from SVN)"
HOMEPAGE="http://developer.berlios.de/svn/"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="x86 ~ppc amd64"

IUSE="ssl kde debug doc"

RDEPEND="ssl? ( dev-libs/openssl )
	kde? ( kde-base/kdebase )
	!kde? ( x11-libs/qt )
	app-text/sablotron
	sys-devel/flex
	>=sys-devel/automake-1.7
	>=sys-devel/autoconf-2.5
	dev-libs/libxslt"
DEPEND="${RDEPEND}"

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

src_compile () 
{
	export WANT_AUTOCONF=2.5
	export WANT_AUTOMAKE=1.7

	set-qtdir 3
	set-kdedir 3

	UNSERMAKE="" make -f admin/Makefile.common || die

	econf `use_enable ssl openssl` \
		`use_enable kde` \
		`use_enable debug` || die "econf failed"

	make clean  || die "Src cleaning failed"
	emake || die "Compilling failed"
}

src_install () 
{
	make DESTDIR=${D} install || die
	useq doc && dodoc TODO README ChangeLog COPYING AUTHORS
}