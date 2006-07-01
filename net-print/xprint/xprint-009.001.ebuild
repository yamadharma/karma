# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit patch extrafiles

IUSE="doc"

SUB_PN=2004-07-07-release

DESCRIPTION="Advanced printing system which enables X11 applications to use devices like printers"
HOMEPAGE="http://xprint.mozdev.org/"
SRC_URI="mirror://sourceforge/xprint/xprint_mozdev_org_source-${SUB_PN}_${PV/./_}.tar.gz
	http://puck.informatik.med.uni-giessen.de/download/xprint_mozdev_org_source-${SUB_PN}_${PV/./_}.tar.gz"

LICENSE="MIT"

SLOT="0"

KEYWORDS="x86 ~ppc ~sparc alpha"

S="${WORKDIR}/${PN}/src/xprint_main/xc"

DEPEND="virtual/x11"

RDEPEND="${DEPEND}
	virtual/lpr"


src_compile() 
{
    sed 's:XPRINTDIR = .*$:XPRINTDIR = /usr/share/Xprint/xserver:' -i config/cf/X11.tmpl
    make XPRINTDIR=/usr/share/Xprint/xserver World || die
}

src_install() 
{
#    make XPRINTDIR=/usr/share/Xprint/xserver XPDESTTARFILE=${S}/xprint.tar.gz make_xprint_tarball -C ${S}/packager
#    sed -i -e "s/^\*default-printer-resolution: 300/\*default-printer-resolution: 600/g" ${S}/programs/Xserver/XpConfig/C/print/attributes/document
    
    local xprintdir=/usr/share/Xprint/xserver
    
    # Create and test tarball of files
    make XPRINTDIR=/usr/share/Xprint/xserver XPDESTTARFILE=${S}/xprint.tar.gz make_xprint_tarball -C ${S}/packager

    # the tarball generation script puts the files which should be installed
    # in the "install/" subdir. we strip the tarball README and the
    # tarball-specific "run_xprint_from_tarball.sh" and then move all stuff
    # in install/* to $PWD

    tar -xzf xprint.tar.gz
    rm -f xprint/run_xprint_from_tarball.sh
    rm -f xprint/README
    mv xprint/install/* ${D}
    rmdir xprint
    
    # this is a really nasty package, so we have to clean up a bit
    dodir /usr/sbin
    mv ${D}/etc/init.d/xprint ${D}/usr/sbin/
    
    # remove obsolete README and SECURITY extension config "SecurityPolicy"
    dodoc ${D}/${xprintdir}/README
    rm -f ${D}/${xprintdir}/README

    # SECURITY extension config "SecurityPolicy" (obsolete?)
    dodir /usr/X11R6/lib/X11
    dosym ${xprintdir} /usr/X11R6/lib/X11/xserver
    cp ${S}/programs/Xserver/Xext/SecurityPolicy ${D}/${xprintdir}
    
    # change name
    mv ${D}/usr/X11R6/bin/Xprt ${D}/usr/X11R6/bin/Xprt_xprint_org

#    sed -i -e 's:XPCUSTOMGLUE=default:XPCUSTOMGLUE=DebianGlue:' ${D}/usr/sbin/xprint
    sed -i -e 's:XPRT_BIN="${XPROJECTROOT}/bin/Xprt":XPRT_BIN="${XPROJECTROOT}/bin/Xprt_xprint_org":' ${D}/usr/sbin/xprint
    
    rm -rf ${D}/etc    
    extrafiles_install
    
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
    einfo
    einfo '                        You have to add                            '
    einfo 'export XPSERVERLIST="`/bin/sh /usr/sbin/xprint get_xpserverlist`"'
    einfo '          to your .xinitrc to get things working correctly         '
    einfo
}

# Local Variables:
# mode: sh
# End:
