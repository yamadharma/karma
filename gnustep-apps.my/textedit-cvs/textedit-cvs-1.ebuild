# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/app-gnustep/terminal/terminal-0.9.4.ebuild,v 1.2 2003/07/28 04:06:48 raker Exp $

inherit gnustep-app-gui cvs

IUSE="${IUSE}"

# Savannah not working
#ECVS_SERVER="subversions.gnu.org:/cvsroot/backbone"
#ECVS_MODULE="System"
#ECVS_USER="anonymous"
#ECVS_CVS_OPTIONS="-dP"
#ECVS_ANON="yes"

# 
#ECVS_AUTH="ext"
#ECVS_SERVER="subversions.gnu.org:/cvs-latest/backbone"
#ECVS_MODULE="System"
#ECVS_USER="anoncvs"
#ECVS_CVS_OPTIONS="-dP"

ECVS_AUTH="ext"
ECVS_SERVER="savannah.nongnu.org:/cvsroot/backbone"
ECVS_MODULE="System"
ECVS_USER="anoncvs"
ECVS_CVS_OPTIONS="-dP"



MY_P=System
#S=${WORKDIR}/${MY_P}

S=${WORKDIR}/System/Applications/TextEdit

DESCRIPTION="GNUstep preferences editor"
HOMEPAGE="http://sourceforge.net/projects/prefsapp"
# SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

mydoc="README.rtf TextEdit.rtf"

src_unpack ()
{
    cvs_src_unpack
    
    # FIX GNUSTEP_LDIR
    cd ${WORKDIR}/System
    sed -i -e "s:GNUSTEP_LDIR:GNUSTEP_TARGET_LDIR:g" Backbone.make
}

# Local Variables:
# mode: sh
# End:
