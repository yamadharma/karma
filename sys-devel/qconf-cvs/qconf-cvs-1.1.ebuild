# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/

inherit eutils cvs qt4

ECVS_SERVER="cvs.anywise.org:/psi"
ECVS_MODULE="qconf"

IUSE=""
DESCRIPTION="QConf make configure script for qmake-based project"
HOMEPAGE=""
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~hppa ~ppc ~ppc64 ~sparc x86"
DEPEND=""
S=${WORKDIR}/${ECVS_MODULE}

src_compile() {
    ./configure --qtdir=/usr --prefix=/usr || die
    emake || die
}

src_install() {
    dodir /usr/bin /usr/share/qconf/conf /usr/share/qconf/modules
    insinto /usr/share/qconf/conf
    doins conf/*
    insinto /usr/share/qconf/modules
    doins modules/*
    exeinto /usr/bin
    doexe qconf
    
}