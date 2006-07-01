# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cvs

IUSE=""

#ECVS_SERVER="offline"


ECVS_SERVER="cvs.tiny-tools.sourceforge.net:/cvsroot/tiny-tools"
ECVS_MODULE="tiny-tools"
# ECVS_USER="cvs"
ECVS_CVS_OPTIONS="-dP"


DESCRIPTION="Emacs Tiny Tools is a collection of libraries and packages"
HOMEPAGE="http://tiny-tools.sourceforge.net"
# SRC_URI="mirror://sourceforge/${PN}/emacs-${P}.tar.gz"
LICENSE="GPL"
SLOT="0"
KEYWORDS="x86"

DEPEND="${DEPEND}
	app-editors/emacs
	dev-lang/perl"

S="${WORKDIR}/tiny-tools"

SITELISP=/usr/share/site-lisp/common/packages
SITELISPROOT=/usr/share/site-lisp
SITELISPDOC=/usr/share/site-lisp/doc



src_compile() 
{
    # Sandbox issues
    addpredict "/usr/share/info"

    mkdir -p ${HOME}/tmp
    
    # CVS stuff :
    cd ${S}
    find . -name CVS -exec rm -rf {} \;
    find . -name .cvsignore -exec rm {} \;

    cd ${S}/bin
    perl makefile.pl  \
	--binary emacs \
	--load ${S}/lisp/tiny/load-path.el \
	dos2unix \
	all

#    cd ${S}/bin
#    make || die
}

src_install() 
{
    
    dodir ${SITELISP}/tiny
    cd ${S}/lisp/tiny
    cp *.elc ${D}/${SITELISP}/tiny
    cp *.el ${D}/${SITELISP}/tiny
    cd ${D}/${SITELISP}/tiny
    for i in *.el; do
	gzip $i
    done
    rm -f load-path*
    gzip -d tinypath.el.gz
    
    dodir ${SITELISP}/other
    cd ${S}/lisp/other
    cp *.elc ${D}/${SITELISP}/other
    cp *.el ${D}/${SITELISP}/other
    cd ${D}/${SITELISP}/other
    for i in *.el; do
	gzip $i
    done
#  rm -f tiny-autoload*

#    dodir ${SITELISPDOC}/${PN}/${PV}
    cd ${S}/doc
    dohtml -r html/*
    dodoc txt/*
#   cp -r * ${D}/${SITELISPDOC}/${PN}/${PV}
    
#  exeinto /usr/bin
#  cd ${S}/bin
#  doexe emacs-util.pl
  
}

# Local Variables:
# mode: sh
# End:
