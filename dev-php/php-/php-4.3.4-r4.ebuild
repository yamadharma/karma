# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/dev-php/php/php-4.3.3-r2.ebuild,v 1.1 2003/10/01 21:05:33 robbat2 Exp $

PHPSAPI="cli"
inherit php eutils patch

IUSE="${IUSE} readline"

DESCRIPTION="PHP Shell Interpreter"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc ~alpha ~arm ~hppa ~mips"

DEPEND_EXTRA="readline? ( >=sys-libs/ncurses-5.1 >=sys-libs/readline-4.1 )
	ncurses? ( >=sys-libs/ncurses-5.1 )"
DEPEND="${DEPEND} ${DEPEND_EXTRA}"
RDEPEND="${RDEPEND} ${DEPEND_EXTRA}"

src_unpack ()
{
    php_src_unpack
    patch_apply_patch
    
    ./buildconf --force
    autoconf
}

src_compile () 
{
	# Readline and Ncurses are CLI PHP only
	# readline implies ncurses
	use_ncurses="--without"
	use ncurses || use readline && use_ncurses="--with"
	myconf="${myconf} `use_with readline`"
	myconf="${myconf} ${use_ncurses}-ncurses"

	myconf="${myconf} \
		--enable-cli"

	# --disable-cgi \

	php_src_compile
}


src_install () 
{
	installtargets="${installtargets} install-cli"
	php_src_install

	# php executable is located in ./sapi/cli/
	exeinto /usr/bin
	doexe sapi/cli/php
}

pkg_postinst () 
{
	php_pkg_postinst
	einfo "This is a CLI only build."
	einfo "You can not use it on a webserver."
}

pkg_preinst () 
{
	php_pkg_preinst
}
