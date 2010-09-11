# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils

AUX_PR=""
#MY_P=clip-prg.32-64-2009.252-${PV}${AUX_PR}
MY_P=clip-prg.32-64-2010.233-1.2.6.04.01

DOC_V=1.2.0

DESCRIPTION="Header file allowing to call Fortran routines from C and C++"
HOMEPAGE="http://sourceforge.net/projects/clip-itk"
SRC_URI="http://users.skynet.be/angelo_girardi/it/download/${MY_P}.tgz
	doc? ( 
	    linguas_en? ( mirror://sourceforge/${PN}/clip-doc-en-html-${DOC_V}.tgz )
	    linguas_ru? ( mirror://sourceforge/${PN}/clip-doc-ru-html-${DOC_V}.tgz )
	)"
#KEYWORDS="amd64 x86"
LICENSE="GPL-2"
IUSE="doc linguas_en linguas_ru"
SLOT="0"

RESTRICT=nomirror

DEPEND="app-misc/banner
	virtual/libiconv"
RDEPEND=""

# S=${WORKDIR}/${MY_P}
S=${WORKDIR}/clip-prg.32-64

src_prepare() {
	mkdir ${S}/build
}

src_configure() {
	yes | ./configure local
#	yes | ./local.sh
#	./configure local
}

src_compile_() {
	export CLIPROOT=/usr/lib/clip
	export CLIP_LOCALE_ROOT=${S}/build/${CLIPROOT}
#	make system 
	cd ${S}/clip
	./configure -r -s
	make DESTDIR=${S}/build BINDIR=/usr/bin
	make install DESTDIR=${D} BINDIR=/usr/bin

	export CLIPROOT=${S}/build/${CLIPROOT}
	export LD_LIBRARY_PATH=${S}/build/usr/$(get_libdir):$$LD_LIBRARY_PATH

	cd ${S}/cliplibs
	make
	
	cd ${S}/prg
	make
}

src_install() {

	cd ${S}/clip
	make install DESTDIR=${D}

	cd ${S}/cliplibs
	make install DESTDIR=${D}

	cd ${S}/prg
	make install DESTDIR=${D}

	
	if ( use doc )
	then
	    use linguas_en && dohtml -r ${WORKDIR}/html/en/*
	    use linguas_ru && dohtml -r ${WORKDIR}/html/ru/*
	fi
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
