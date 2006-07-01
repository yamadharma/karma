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

IUSE="ssl kde debug doc spell"

RDEPEND="kde? ( kde-base/kdelibs
			    || ( kde-base/kdebase-data kde-base/kdebase ) )
		 !kde? ( $(qt_min_version 3)
		         spell? ( app-text/aspell ) )
		 ssl? ( dev-libs/openssl )
		 app-text/sablotron
		 sys-devel/flex
		 dev-libs/libxml2
		 dev-libs/libxslt
		 >=sys-devel/automake-1.7
		>=sys-devel/autoconf-2.5"
DEPEND="${RDEPEND}"

pkg_setup() {
	if [ -z ${myver} ] ; then
		ewarn "Building svn version exported on ${myver}."
	fi
	if use kde ; then
		if has_version net-im/sim ; then
			if ! built_with_use net-im/sim kde ; then
				ewarn 'Your system already has sim emerged with USE="-kde".'
				ewarn 'Now you are trying to emerge it with kde support.'
				ewarn 'Sim has problem that leads to compilation failure in such case.'
				ewarn 'To emerge sim with kde support, first clean out previous'
				ewarn 'installation with `emerge -C sim` and then try again.'
				die "Previous installation found. Unmerge it first."
			fi
		fi
		if use spell; then
			if ! built_with_use kde-base/kdelibs spell ; then
				ewarn "kde-base/kdelibs were merged without spell in USE."
				ewarn "Thus spelling will not work in sim. Please, either"
				ewarn "reemerge kde-base/kdelibs with spell in USE or emerge"
				ewarn 'sim with USE="-spell" to avoid this message.'
				ebeep
			fi
		else
			if built_with_use kde-base/kdelibs spell ; then
				ewarn 'kde-base/kdelibs were merged with spell in USE.'
				ewarn 'Thus spelling will work in sim. Please, either'
				ewarn 'reemerge kde-base/kdelibs without spell in USE or emerge'
				ewarn 'sim with USE="spell" to avoid this message.'
				ebeep
			fi
		fi
		if ! built_with_use kde-base/kdelibs arts ; then
			myconf="--without-arts"
		fi
	else
		if has_version net-im/sim ; then
			if built_with_use net-im/sim kde ; then
				ewarn 'Your system already has sim emerged with USE="kde".'
				ewarn 'Now you are trying to emerge it without kde support.'
				ewarn 'Sim has problem that leads to compilation failure in such case.'
				ewarn 'To emerge sim without kde support, first clean out previous'
				ewarn 'installation with `emerge -C sim` and then try again.'
				die "Previous installation found. Unmerge it first."
			fi
		fi
	fi
}

src_compile() {
#	epatch ${FILESDIR}/sim-0.9.4-gcc34.diff
#	epatch ${FILESDIR}/sim-0.9.4-alt-histpreview-apply-fix.diff
	export WANT_AUTOCONF=2.5
	export WANT_AUTOMAKE=1.7

	set-qtdir 3

	if use kde 
	    then
	    set-kdedir 3
	fi

	make -f admin/Makefile.common

	if ! use kde 
	    then
	    use spell || export DO_NOT_COMPILE="$DO_NOT_COMPILE plugins/spell"
	fi

	econf ${myconf} `use_enable kde` \
		  `use_with ssl` \
		  `use_enable debug` || die "econf failed"

#	econf `use_enable ssl openssl` \
#		`use_enable kde` \
#		`use_enable debug` || die "econf failed"

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