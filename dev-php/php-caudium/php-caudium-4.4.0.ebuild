# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/php-cgi/php-cgi-4.3.9.ebuild,v 1.7 2004/09/30 13:09:58 vapier Exp $

PHPSAPI="caudium"
inherit php-sapi eutils gnuconfig

DESCRIPTION="PHP module for Caudium Web Server"
SLOT="0"
KEYWORDS="x86 sparc alpha hppa ppc ia64"

# for this revision only
PDEPEND=">=${PHP_PROVIDER_PKG}-${PV}"
PROVIDE="${PROVIDE} virtual/httpd-php"

PATCHDIR="${FILESDIR}/patch/majorversion/4.4"

src_unpack ()
{
	multiinstwarn

	php-sapi_src_unpack
	
	cd ${S}
    
        EPATCH_FORCE="yes"
	EPATCH_SUFFIX="patch"
        epatch ${PATCHDIR}

        ./buildconf --force
	gnuconfig_update ${S}
}

src_compile () 
{
	# CLI needed to build stuff
	myconf="${myconf} \
		--with-caudium=/usr/lib/caudium"

	php-sapi_src_compile
}


src_install () 
{
	PHP_INSTALLTARGETS="install"
	php-sapi_src_install

	# rename binary
#	mv ${D}/usr/bin/php ${D}/usr/bin/php-cgi
}

pkg_postinst () 
{
	php-sapi_pkg_postinst
	einfo "This is a Caudium only build."
}
