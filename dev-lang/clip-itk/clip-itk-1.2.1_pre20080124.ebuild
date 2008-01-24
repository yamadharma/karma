# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils cvs

ECVS_CVS_COMMAND="cvs -q"
ECVS_CVS_COMPRESS="-z3"
ECVS_SERVER="clip-itk.cvs.sourceforge.net:/cvsroot/clip-itk"
ECVS_USER="anonymous"
ECVS_AUTH="pserver"
ECVS_MODULE="clip-all"
ECVS_CO_OPTS="-D ${PV/*_pre} -P"
ECVS_UP_OPTS="-D ${PV/*_pre} -dP"

S=${WORKDIR}/${ECVS_MODULE}

#AUX_PR="-0"
#MY_P=clip-prg-${PV}${AUX_PR}
#S=${WORKDIR}/${MY_P}

DESCRIPTION="Clipper/Xbase compatible compiler"
HOMEPAGE="http://sourceforge.net/projects/clip-itk"
#SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tgz
#	doc? ( mirror://sourceforge/${PN}/clip-doc-en-html-${PV}.tgz 
#	    linguas_ru? ( mirror://sourceforge/${PN}/clip-doc-ru-html-${PV}.tgz )
#	)"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"
IUSE="doc linguas_ru 
mysql gd postgres oracle interbase odbc gtk2 ssl glade fcgi"
SLOT="0"

DEPEND="sys-libs/zlib 
	app-arch/bzip2
	ssl? ( dev-libs/openssl )
	fcgi? ( dev-libs/fcgi )
	gtk2? ( =x11-libs/gtk+-2* 
		glade? ( gnome-base/libglade )
        )
	mysql? ( dev-db/mysql )
	postgres? ( dev-db/libpq )
	oracle? ( dev-db/oracle-instantclient-basic )
	odbc? ( dev-db/libiodbc )
	dev-libs/expat"
RDEPEND=""

BUILD_DIR=${S}/build
PKG_CLIPROOT=/usr/$(get_libdir)/clip

src_compile() {
	CLIPLIBS="clip-gzip
	    clip-bzip2 
	    clip-xml
    	    clip-com 
    	    clip-oasis 
    	    clip-rtf 
    	    clip-r2d2
    	    clip-ui 
    	    clip-postscript"

	use ssl && CLIPLIBS="${CLIPLIBS} clip-crypto"
	use gd && CLIPLIBS="${CLIPLIBS} clip-gd"
	use fcgi && CLIPLIBS="${CLIPLIBS} clip-fcgi"

	if ( use gtk2 ) 
	then
	    CLIPLIBS="${CLIPLIBS} clip-gtk2"
#	    use glade && CLIPLIBS="${CLIPLIBS} clip-glade2 "
	fi	    

	use mysql && CLIPLIBS="${CLIPLIBS} clip-mysql"
	use postgres && CLIPLIBS="${CLIPLIBS} clip-postgres"
	use oracle && CLIPLIBS="${CLIPLIBS} clip-oracle"
	use interbase && CLIPLIBS="${CLIPLIBS} clip-interbase"
#	use odbc && CLIPLIBS="${CLIPLIBS} clip-odbc"

	mkdir ${BUILD_DIR}

	export CLIP_LANG=POSIX
#	export CLIP_LANG=ru_RU.KOI8-R	
	export CLIPROOT=${BUILD_DIR}/${PKG_CLIPROOT}
	export CLIP_LOCALE_ROOT=${BUILD_DIR}/${PKG_CLIPROOT}
	export STD_LIBDIR=${BUILD_DIR}/usr/$(get_libdir)

	cd ${S}/clip
	./configure -o || die
	make 
	make install DESTDIR=${BUILD_DIR} BINDIR=/usr/bin CLIPROOT=${PKG_CLIPROOT}

	export LD_LIBRARY_PATH=${BUILD_DIR}${PKG_CLIPROOT}/lib:$$LD_LIBRARY_PATH
	export PATH=${BUILD_DIR}${PKG_CLIPROOT}/bin:$PATH
	
	use amd64 && sed -i -e "s:^C_FLAGS=\(.*\):C_FLAGS=\1 -fPIC:" ${BUILD_DIR}/${PKG_CLIPROOT}/include/Makefile.inc

	for i in ${CLIPLIBS}
	do
	    cd ${S}/cliplibs/${i}
	    [ -x ./configure ] && ( ./configure || die )
	    make || die
	    make install || die
	done
	
	cd ${S}/prg
	make || die
	make install || die

	if ( use doc )
	then
	    cd ${S}/doc
	    make || die # html LANGS="ru en" USEUTF=1
	    make install || die
	fi

}

src_test () (
	echo "nothing to test"
)

src_install() {
	cp -R ${BUILD_DIR}/* ${D}/

	dodir /usr/share/doc/${PF}
	mv ${D}/${PKG_CLIPROOT}/doc/* ${D}/usr/share/doc/${PF}
	rm -rf ${D}/${PKG_CLIPROOT}/doc
	
	dodir /usr/share/doc/${PF}/example/example
	cp -R ${S}/example/* ${D}/usr/share/doc/${PF}/example/example

	rm -rf `find ${D} -path '*CVS*'`

	rm -f ${D}/usr/bin/*
	cd ${D}/usr/bin/
	ln -snf ../$(get_libdir)/clip/bin/clip* .
	ln -snf ../$(get_libdir)/clip/bin/codb* .
	
	cd ${D}/usr/$(get_libdir)
	ln -snf ./clip/lib/libclip* .
	ln -snf ./clip/lib/libcodb* .

	echo "-v0" > ${D}$${PKG_CLIPROOT}/cliprc/clipflags
	echo "-O" >> ${D}$${PKG_CLIPROOT}/cliprc/clipflags
	echo "-r" >> ${D}$${PKG_CLIPROOT}/cliprc/clipflags
	echo "-l" >> ${D}$${PKG_CLIPROOT}/cliprc/clipflags

	dodir /etc/env.d
	echo "CLIPROOT=${PKG_CLIPROOT}" > ${D}/etc/env.d/50clip
	echo "CLIP_LANG=POSIX" >> ${D}/etc/env.d/50clip
}
