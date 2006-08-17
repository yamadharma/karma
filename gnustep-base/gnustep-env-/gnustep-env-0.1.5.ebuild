# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="This is a convience package that installs all base GNUstep libraries, convenience scripts, and environment settings for use on Gentoo."
# These are support files for GNUstep on Gentoo, so setting
#   homepage thusly
HOMEPAGE="http://www.gnustep.org"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

IUSE=""
DEPEND=""
RDEPEND=""

if [ -z "${GENTOO_GNUSTEP_ROOT}" ]
    then
    GENTOO_GNUSTEP_ROOT=/usr/GNUstep
fi

GNUSTEP_ROOT=${GENTOO_GNUSTEP_ROOT}

GNUSTEP_SYSTEM_ROOT=${GNUSTEP_ROOT}/System
GNUSTEP_LOCAL_ROOT=${GNUSTEP_ROOT}/Local
GNUSTEP_NETWORK_ROOT=${GNUSTEP_ROOT}/Network

src_compile () 
{
    echo "nothing to compile"
}

src_install () 
{
    dodir /etc/env.d
    echo "GENTOO_GNUSTEP_ROOT=${GENTOO_GNUSTEP_ROOT}" > ${D}/etc/env.d/10gnustep_root

    echo "MANPATH=${GNUSTEP_SYSTEM_ROOT}/Library/Documentation/man:${GNUSTEP_LOCAL_ROOT}/Library/Documentation/man:${GNUSTEP_NETWORK_ROOT}/Library/Documentation/man" >> ${D}/etc/env.d/10gnustep_env
    echo "INFOPATH=${GNUSTEP_SYSTEM_ROOT}/Library/Documentation/info:${GNUSTEP_LOCAL_ROOT}/Library/Documentation/info:${GNUSTEP_NETWORK_ROOT}/Library/Documentation/info" >> ${D}/etc/env.d/10gnustep_env
    
    docinto env.d
    dodoc ${FILESDIR}/misc/doc/env.d/*
}

pkg_postinst () 
{
    #==============================================================
    # Add lines for gdomap into /etc/services, if not already there
    #==============================================================
    grep -q '^gdomap' /etc/services                                            \
	|| (echo "gdomap 538/tcp # GNUstep distributed objects" >> /etc/services  \
	&& echo "gdomap 538/udp # GNUstep distributed objects" >> /etc/services)

    # {{{ Variables
    
    if [ ! -f /etc/env.d/05i18n_gnustep ]    
	then
	zcat /usr/share/doc/${PF}/env.d/05i18n_gnustep.gz > /etc/env.d/05i18n_gnustep
    fi

    if [ ! -f /etc/env.d/10gnustep ]    
	then
	zcat /usr/share/doc/${PF}/env.d/10gnustep.gz > /etc/env.d/10gnustep
    fi

    # }}}

    env-update &> /dev/null
    source /etc/profile
}


pkg_postrm () 
{
    #=========================================
    # Remove lines for gdomap in /etc/services
    #=========================================
    mv -f /etc/services /etc/services.orig
    grep -v "^gdomap 538" /etc/services.orig > /etc/services
    rm -f /etc/services.orig
}

# Local Variables:
# mode: sh
# End:

