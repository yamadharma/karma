# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/net-print/foomatic/foomatic-2.0.2.ebuild,v 1.4 2003/05/19 19:57:02 mholzer Exp $

inherit perl-module

IUSE="doc"

DESCRIPTION="Advanced printing system which enables X11 applications to use devices like printers"
HOMEPAGE="http://xprint.mozdev.org/"
SRC_URI="http://puck.informatik.med.uni-giessen.de/download/xprint_mozdev_org_source-2003-05-08-release_008.tar.gz"

LICENSE="MIT"
SLOT="0"

KEYWORDS="x86 ~ppc ~sparc alpha"


S="${WORKDIR}/${PN}/src/xprint_main/xc"

DEPEND="virtual/x11"

src_unpack() 
{
	unpack ${A}
	cd ${S}
}

src_compile() 
{
    make World
}

src_install() 
{
#    emake install DESTDIR=${D} || die "installation error"

    # Create and test tarball of files
    cd ${S}/packager
    # ${XPDESTTARFILE} is used by "make make_xprint_tarball"
    XPDESTTARFILE="${T}/xprint_rpm_`date +%y%m%d%H%M%S`.tar.gz"
    export XPDESTTARFILE
    make make_xprint_tarball
    
    # Check if the temp. tarball was being build
    if [ ! -f "${XPDESTTARFILE}" ] ; 
    then
	die "temp. tarball missing."
    fi

    # ... and then unpack the temp. tarball in the ${D} dir
    cd ${D}
    gunzip -c ${XPDESTTARFILE} | tar -xvf -
    rm -f ${XPDESTTARFILE}
    
    # the tarball generation script puts the files which should be installed
    # in the "install/" subdir. we strip the tarball README and the
    # tarball-specific "run_xprint_from_tarball.sh" and then move all stuff
    # in install/* to $PWD
    rm -f xprint/run_xprint_from_tarball.sh
    rm -f xprint/README
    mv xprint/install/* .
    rmdir xprint/install
    rmdir xprint
    
    # remove obsolete README and SECURITY extension config "SecurityPolicy"
    rm -f ${D}/usr/X11R6/lib/X11/xserver/README
    rm -f ${D}/usr/X11R6/lib/X11/xserver/SecurityPolicy
    
    mv ${D}/usr/X11R6/bin/Xprt ${D}/usr/X11R6/bin/Xprt_xprint_org

    if [ ! -f ${D}/usr/X11R6/lib/X11/xserver/C/print/models/PSdefault/model-config ] ; 
    then
	die "ERROR: ${D}/usr/X11R6/lib/X11/xserver/C/print/models/PSdefault/model-config missing."
    fi
    
    rm -rf ${D}/etc
    # {{{ Init install
    
    dodir /etc
    exeinto /etc/init.d
    doexe ${FILESDIR}/init/gentoo-sysv/version/${PV}/init.d/*
    insinto /etc/conf.d
    doins ${FILESDIR}/init/gentoo-sysv/version/${PV}/conf.d/*
    insinto /etc/env.d
    doins ${FILESDIR}/init/gentoo-sysv/version/${PV}/env.d/*
    
    # }}}
    # {{{ Install docs
    
    cd ${S}
    dodoc doc/hardcopy/XPRINT/Xprint_FAQ.txt
    
    if ( use doc )
    then
	cd ${S}
	docinto XPRINT
        dodoc doc/hardcopy/XPRINT/*.PS.gz
	docinto XLFD	
        dodoc doc/hardcopy/XLFD/*.PS.gz	
    fi
    
    # }}}
}

pkg_postinst() 
{
    einfo "Notes:"
    einfo "1. You have to start the Xprint servers using % /etc/init.d/xprint start #"
    einfo "   and relogin (to populate the XPSERVERLIST env variable using"
    einfo "   /etc/profile.d/xprint) before using any Xprint-based applications."
    einfo "2. Please consult the FAQ (/usr/doc/packages/xprint/Xprint_FAQ.txt)"
    einfo "   or http://xprint.mozdev.org/ if there are any problems."
}



