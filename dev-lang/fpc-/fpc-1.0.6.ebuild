# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/dev-lang/gpc/gpc-20030209.ebuild,v 1.3 2003/02/16 00:15:35 vapier Exp $

#inherit flag-o-matic libtool
#inherit flag-o-matic

IUSE="doc"


RPM_V="1"

S="${WORKDIR}"
DESCRIPTION="The Free Pascal Compiler is a Turbo Pascal 7.0 and Delphi compatible 32bit Pascal Compiler"
SRC_URI="ftp://ftp.freepascal.org/pub/fpc/dist/Linux/rpm/${P}-${RPM_V}.i386.rpm
ftp://ftp.freepascal.org/pub/fpc/dist/Linux/rpm/${P}-${RPM_V}.src.rpm
doc? ftp://ftp.freepascal.org/pub/fpc/dist/Linux/rpm/${PN}-docs-${PV}-${RPM_V}.src.rpm"

HOMEPAGE="http://www.freepascal.org/"

SLOT="0"
KEYWORDS="x86 ~sparc"
LICENSE="GPL-2"

DEPEND="virtual/glibc
	app-arch/rpm
	app-arch/rpm2targz
	doc?	app-text/tetex
	"

# Theoretical cross compiler support
[ ! -n "${CCHOST}" ] && export CCHOST="${CHOST}"

LOC="/usr"
#GCC_PVR=$(emerge -s gcc|grep "installed: 3.2"|cut -d ':' -f 2)
LIBPATH="${LOC}/lib/gcc-lib/${CCHOST}/${GCC_PV}"
#BINPATH="${LOC}/${CCHOST}/gcc-bin/${GCC_PV}"
DATAPATH="${LOC}/share"
# Dont install in /usr/include/g++-v3/, but in gcc internal directory.
# We will handle /usr/include/g++-v3/ with gcc-config ...
STDCXX_INCDIR="${LIBPATH}/include/g++-v${MY_PV/\.*/}"

src_unpack() 
{
	cd ${WORKDIR}

	rpm2targz ${DISTDIR}/${P}-${RPM_V}.i386.rpm
	tar zxf ${P}-${RPM_V}.i386.tar.gz
	rm -f ${P}-${RPM_V}.i386.tar.gz

	rpm2targz ${DISTDIR}/${P}-${RPM_V}.src.rpm
	tar zxf ${P}-${RPM_V}.src.tar.gz
	tar zxf ${P}-src.tar.gz
	rm -f ${P}-${RPM_V}.src.tar.gz ${P}-src.tar.gz

    if use doc
    then
	rpm2targz ${DISTDIR}/${PN}-docs-${PV}-${RPM_V}.src.rpm
	tar zxf ${PN}-docs-${PV}-${RPM_V}.src.tar.gz
	tar zxf ${PN}-docs-${PV}-src.tar.gz
	rm -f ${PN}-docs-${PV}-${RPM_V}.src.tar.gz ${PN}-docs-${PV}-src.tar.gz
    fi

#	cd ${S}
#	sed "s:..RPM_OPT_FLAGS.:${CFLAGS}:" \
#		< Makefile > Makefile.new
#	mv -f Makefile.new Makefile
}


src_compile() 
{
	local myconf

	PATH=${PATH}:${S}/usr/bin:${S}/usr/lib/fpc/${PV}
	export PATH

	NEWPP=${S}/compiler/ppc386
	
	make compiler_cycle FPC_VERSION=`ppc386 -iV`
	make rtl_clean rtl_smart FPC=${NEWPP}
	make packages_base_smart FPC=${NEWPP}
	make fcl_smart FPC=${NEWPP}
	make packages_extra_smart FPC=${NEWPP}
	make utils_all FPC=${NEWPP}

    cd ${S}
    if use doc
    then
	yes "s" | make -C docs pdf
    fi	
	
	
	
}

src_install () 
{
	NEWPP=${S}/compiler/ppc386

	INSTALLOPTS="FPC=${NEWPP} INSTALL_PREFIX=${D}/usr INSTALL_DOCDIR=${D}/usr/share/doc/${P}"
	
	make compiler_distinstall ${INSTALLOPTS}
	make rtl_distinstall ${INSTALLOPTS}
	make packages_distinstall ${INSTALLOPTS}
	make fcl_distinstall ${INSTALLOPTS}
	make utils_distinstall ${INSTALLOPTS}

	make demo_install ${INSTALLOPTS} INSTALL_SOURCEDIR=${D}/usr/share/doc/${P}
	make doc_install ${INSTALLOPTS}
	make man_install ${INSTALLOPTS}
	
	mv -f ${D}/usr/doc/${P}/*  ${D}/usr/share/doc/${P}
	rm -rf ${D}/usr/doc

    cd ${S}
    if use doc
    then
	make -C docs pdfinstall DOCINSTALLDIR=${D}/usr/share/doc/${P}/pdf
    fi
}
