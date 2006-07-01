# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/sys-libs/db/db-4.1.25_p1-r1.ebuild,v 1.3 2003/09/17 21:59:15 avenj Exp $

IUSE="tcltk java doc"

inherit eutils
inherit db

MY_P=${P}

S=${WORKDIR}/${MY_P}/build_unix
DESCRIPTION="Berkeley DB"
SRC_URI="http://www.sleepycat.com/update/snapshot/${MY_P}.tar.gz"

HOMEPAGE="http://www.sleepycat.com"
SLOT="4.2"
LICENSE="DB"
KEYWORDS="~x86 ~amd64 ~ia64"

DEPEND="tcltk? ( >=dev-lang/tcl-8.4 )
	java? ( virtual/jdk )"

src_compile () 
{
	local myconf

	use java \
		&& myconf="${myconf} --enable-java" \
		|| myconf="${myconf} --disable-java"

	use tcltk \
		&& myconf="${myconf} --enable-tcl --with-tcl=/usr/lib" \
		|| myconf="${myconf} --disable-tcl"

	if use java && [ -n "${JAVAC}" ]; then
		export PATH=`dirname ${JAVAC}`:${PATH}
		export JAVAC=`basename ${JAVAC}`
	fi

	../dist/configure \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--datadir=/usr/share \
		--sysconfdir=/etc \
		--localstatedir=/var/lib \
		--enable-compat185 \
		--enable-cxx \
		--with-uniquename \
		${myconf} || die

	emake || make || die
}

src_install () 
{

	einstall || die

	db_src_install_usrbinslot

	db_src_install_headerslot

	db_src_install_doc

	db_src_install_usrlibcleanup
}

pkg_postinst () 
{
	db_fix_so
}

pkg_postrm () 
{
	db_fix_so
}
