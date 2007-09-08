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
#	doc? ( 
#	    linguas_en? ( mirror://sourceforge/${PN}/clip-doc-en-html-${PV}.tgz )
#	    linguas_ru? ( mirror://sourceforge/${PN}/clip-doc-ru-html-${PV}.tgz )
#	)"
KEYWORDS="amd64 x86"
LICENSE="GPL-2"
IUSE="doc linguas_en linguas_ru 
mysql gd postgres oracle interbase odbc gtk2"
SLOT="0"

DEPEND=""
RDEPEND=""

CLIPLIBS="clip-gzip
	    clip-bzip2 
	    clip-crypto 
	    clip-gd 
	    clip-fcgi 
    	    clip-gtk2 
    	    clip-mysql 
    	    clip-postgres 
    	    clip-oracle 
    	    clip-interbase 
    	    clip-odbc 
    	    clip-com 
    	    clip-oasis 
    	    clip-rtf 
    	    clip-r2d2 
    	    clip-xml 
    	    clip-glade2 
    	    clip-ui 
    	    clip-postscript"

BUILD_DIR=${S}/build
PKG_CLIPROOT=/usr/lib/clip

src_compile() {
	mkdir ${S}/build
	
#	export CLIP_LANG=ru_RU.KOI8-R 
	export CLIP_LANG=POSIX
	export CLIPROOT=${BUILD_DIR}/${PKG_CLIPROOT}
	export CLIP_LOCALE_ROOT=${BUILD_DIR}/${PKG_CLIPROOT}
	export STD_LIBDIR=${BUILD_DIR}/usr/$(get_libdir)
#	make system 
	cd ${S}/clip
	./configure -o -s || die
	make 
	make install DESTDIR=${BUILD_DIR} BINDIR=/usr/bin CLIPROOT=${PKG_CLIPROOT}

#	export CLIPROOT=${BUILD_DIR}/${PKG_CLIPROOT}
	export LD_LIBRARY_PATH=${BUILD_DIR}/usr/$(get_libdir):$$LD_LIBRARY_PATH
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

#	cd ${S}/prg/doc_utils
#	make || die
#	make install || die

	if ( use doc )
	then
	    cd ${S}/doc
	    make html LANGS="ru en" USEUTF=1 || die
	fi

}

src_install() {

	cd ${S}/clip
	make install DESTDIR=${D} BINDIR=/usr/bin || die

#	cd ${S}/cliplibs
#	make install DESTDIR=${D}

	cd ${S}/prg
	make install || die

	echo "-v0" > ${D}$${PKG_CLIPROOT}/cliprc/clipflags
	echo "-O" >> ${D}$${PKG_CLIPROOT}/cliprc/clipflags
	echo "-r" >> ${D}$${PKG_CLIPROOT}/cliprc/clipflags
	echo "-l" >> ${D}$${PKG_CLIPROOT}/cliprc/clipflags

	
#	if ( use doc )
#	then
#	    use linguas_en && dohtml -r ${WORKDIR}/html/en/*
#	    use linguas_ru && dohtml -r ${WORKDIR}/html/ru/*
#	fi


}

#SCLIPROOT=usr/local/clip
#export CLIPROOT=/$(SCLIPROOT)
#PWD=$(shell pwd)
#DESTDIR=$(PWD)/debian/tmp
#CLIP_LOCALE_ROOT=$(DESTDIR)$(CLIPROOT)
#export DESTDIR SCLIPROOT CLIP_LOCALE_ROOT
##
##DOC_LANGS=en
#DOC_LANGS=en ru

#	# Add here commands to compile the package.
#	mkdir -p debian/tmp$(CLIPROOT)/include
#	cd clip; ./configure -r
#	cd clip; $(MAKE) install DESTDIR=$(DESTDIR)
#	#cd tdoc; $(MAKE) CLIPROOT=$(DESTDIR)/$(CLIPROOT)
#	#cd tdoc; $(MAKE) install DESTDIR=$(DESTDIR)
#	-export CLIPROOT=$(DESTDIR)$(CLIPROOT) ;\
#		export LD_LIBRARY_PATH=$(DESTDIR)/usr/lib:$$LD_LIBRARY_PATH ;\
#		cd prg/doc_utils && $(MAKE) && $(MAKE) install DESTDIR=$(DESTDIR)
#	-cd doc && $(MAKE) html CLIPROOT=$(DESTDIR)/$(CLIPROOT) LANGS='$(DOC_LANGS)' #USEUTF=1
#	-cd doc && $(MAKE) install DESTDIR=$(DESTDIR) LANGS='$(DOC_LANGS)' #USEUTF=1
#	-rm -f $(DESTDIR)/$(CLIPROOT)/bin/ftosgml
#	-rm -f $(DESTDIR)/$(CLIPROOT)/bin/ctosgml
#
#	echo "-v0" > ${DESTDIR}${CLIPROOT}/cliprc/clipflags
#	echo "-O" >> ${DESTDIR}${CLIPROOT}/cliprc/clipflags
#	echo "-r" >> ${DESTDIR}${CLIPROOT}/cliprc/clipflags
#	echo "-l" >> ${DESTDIR}${CLIPROOT}/cliprc/clipflags
#	mkdir -p $(DESTDIR)$(CLIPROOT)/doc
#	cp -a example $(DESTDIR)$(CLIPROOT)/doc/
#
#	cd $(PWD)/debian/tmp$(CLIPROOT)/; rm -rf `find . -path '*CVS*'`
#	rm -f $(PWD)/debian/tmp$(CLIPROOT)/lib/Make
#
