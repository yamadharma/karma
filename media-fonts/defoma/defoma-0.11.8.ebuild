# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


inherit eutils

IUSE="X"

AUX_V="-0.1"

DESCRIPTION="Simple interface for editing the font path for the X font server"
HOMEPAGE="ftp://ftp.debian.org/debian/pool/main/d/defoma/"
SRC_URI="ftp://ftp.debian.org/debian/pool/main/d/defoma/${P/-/_}${AUX_V}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64 ~ppc ~sparc ~alpha ~hppa ~mips"

DEPEND="dev-lang/perl"

RDEPEND="${DEPEND}
	dev-util/dialog
	X? dev-perl/glade-perl"

src_compile () 
{
	einfo "Nothing to compile"	
}

src_install  () 
{
	local installvendorlib
	eval `perl '-V:installvendorlib'`
	
	# common
		
	dobin src/defoma*
	
	insinto ${installvendorlib}/Debian/Defoma
	doins pm/Defoma/*.pm

	insinto /usr/share/defoma
	doins libs/*
	chmod +x ${D}/usr/share/defoma/defoma-test.sh

	insinto /etc/defoma
	doins conf/*
	
	dosym /usr/bin/defoma /usr/bin/defoma-font
	dosym /usr/bin/defoma /usr/bin/defoma-app
	dosym /usr/bin/defoma /usr/bin/defoma-subst
	dosym /usr/bin/defoma /usr/bin/defoma-id
	dosym /usr/bin/defoma /usr/bin/defoma-user

	
	# psfontmgr
	
	dobin psfontmgr/src/*

	insinto /usr/share/defoma
	doins psfontmgr/libs/*

	insinto /usr/share/defoma/scripts
	doins debian/psfontmgr.defoma

	# dfontmgr
	
	if ( use X )
	    then
	
	    dobin dfontmgr/Dfontmgr/dfontmgr

	    insinto /usr/share/defoma
	    doins dfontmgr/libs/*

	    insinto ${installvendorlib}/Debian/Dfontmgr
	    doins dfontmgr/Dfontmgr/*.pm

	    insinto ${installvendorlib}/Debian/DefomaWizard
	    doins dfontmgr/DefomaWizard/*.pm
	
	    dosed -ie "s:/usr/share/perl5/Debian:${installvendorlib}/Debian:g" /usr/bin/dfontmgr
	    dosed -ie "s:/usr/share/perl5/Debian:${installvendorlib}/Debian:g" /usr/share/defoma/libgtk.pl
	    dosed -ie "s:/usr/share/perl5/Debian:${installvendorlib}/Debian:g" ${installvendorlib}/Debian/Dfontmgr/Dfontmgr.pm
	
	fi

	# man
		
	doman man/* 
	doman psfontmgr/man/* 
	use X && doman dfontmgr/man/*
	
	# doc
	
	dodoc debian/README* debian/changelog 
	
	dodoc doc/*
	docinto examples
	dodoc examples/* 
	
	# misc
	
	keepdir /etc/defoma/hints
	keepdir /var/lib/defoma/scripts
	keepdir /var/lib/defoma/psfontmgr.d
}

pkg_postinst ()
{
	/usr/bin/defoma-reconfigure
	/usr/bin/defoma-app -t update psfontmgr
}