# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# Author Dmitry S. Kulyabov <dharma@mx.pfu.edu.ru>
# $Header: $

# This eclass sets the site-lisp directory for emacs-related packages.

inherit gnustep-2 subversion 

ECLASS=etoile-svn
INHERITED="$INHERITED $ECLASS"

ESVN_PROJECT=etoile

ESVN_OPTIONS="-r${PV/*_pre}"
ESVN_REPO_URI="http://svn.gna.org/svn/etoile/trunk/Etoile"
ESVN_STORE_DIR="${PORTAGE_ACTUAL_DISTDIR-${DISTDIR}}/svn-src/etoile"


HOMEPAGE="http://www.etoile-project.org"
#SRC_URI=""

LICENSE="GPL-2"

mydoc=""

#FEATURES="${FEATURES} nostrip"

#export PROJECT_DIR=${S1}

etoile-svn_src_compile() {
	cd ${S1}
	export PROJECT_DIR=${S1}
	gnustep-base_src_compile 
}

etoile-svn_src_install() {
	cd ${S1}
	gnustep-base_src_install
	
	if [ -n "${mydoc}" ]
	then
	    dodoc ${mydoc}
	fi
}


EXPORT_FUNCTIONS src_compile src_install

# Local Variables:
# mode: sh
# End:
