# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/dev-util/gnustep-base/gnustep-base-1.7.1.ebuild,v 1.1 2003/07/13 20:58:34 raker Exp $

inherit gnustep-base

DESCRIPTION="GNUstep base package"
HOMEPAGE="http://www.gnustep.org"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/core/${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86 -ppc ~sparc"

IUSE="doc"

DEPEND="${DEPEND}
	=gnustep-base/gnustep-make-${PV}*
	virtual/glibc
	>=sys-devel/gcc-3.2
	>=dev-libs/libxml2-2.4.24
	>=dev-libs/ffcall-1.8d
	>=dev-libs/gmp-4.1"
	
myconf="--with-xml-prefix=/usr \
	--with-gmp-include=/usr/include \
	--with-gmp-library=/usr/lib"

src_install () 
{
    gnustep_src_install
    exeinto /etc/init.d 
    doexe ${FILESDIR}/gnustep
}

pkg_postinst() 
{
    einfo "You should set the local timezone and language with the defaults command now."
    einfo
    einfo "i.e. \"defaults write NSGlobalDomain \"Local Time Zone\" America/Chicago\""
    einfo "     \"defaults write NSGlobalDomain NSLanguages \"English\"\""
    einfo
    einfo "Time zones can be found in"
    einfo "  /usr/GNUstep/System/Libraries/Resources/NSTimeZones/zones/"
    einfo
    einfo "Make sure that you type"
    einfo "  \". /usr/GNUstep/System/Makefiles/GNUstep.sh\" first to set the right PATH"
    einfo
    einfo "For GNUstep to work properly \"gnustep\" should be added to your default"
    einfo "  runlevel.  This can be done by typing \"rc-update add gnustep default\"."
}

# Local Variables:
# mode: sh
# End:
