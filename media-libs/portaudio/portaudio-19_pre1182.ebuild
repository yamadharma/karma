# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils subversion

ESVN_PROJECT=v19-devel

ESVN_OPTIONS="-r${PV/*_pre}"
ESVN_REPO_URI="https://www.portaudio.com/repos/portaudio/branches/${ESVN_PROJECT}"
ESVN_STORE_DIR="${PORTAGE_ACTUAL_DISTDIR-${DISTDIR}}/svn-src/www.portaudio.com"

S=${WORKDIR}/${ESVN_PROJECT}



DESCRIPTION="An open-source cross platform audio API."
HOMEPAGE="http://www.portaudio.com"
#SRC_URI="http://www.portaudio.com/archives/${MY_P}.zip"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ~hppa ~mips ~ppc ~ppc-macos ~ppc64 ~sparc ~x86"
IUSE="oss alsa jack doc nocxx"

DEPEND="alsa? ( >=media-libs/alsa-lib-0.9 )
	jack? ( >=media-sound/jack-audio-connection-kit-0.100.0 )
	dev-util/scons"

RDEPEND="virtual/libc
	alsa? ( >=media-libs/alsa-lib-0.9 )
	jack? ( >=media-sound/jack-audio-connection-kit-0.100.0 )"

src_compile() {
	scons_compile(){
		mkdir -p ${D}/usr
		local myconf="enableShared=1 prefix=${D}/usr enableStatic=0 enableAsserts=0"
		! use jack; myconf="${myconf} useJACK=$?"
		! use alsa; myconf="${myconf} useALSA=$?"
		! use oss; myconf="${myconf} useOSS=$?"
		use nocxx || myconf="${myconf} enableCxx=1"

		# FIXME dirty hack
		use amd64 && CFLAGS="${CFLAGS} -DALLOW_SMP_DANGERS=1"

		einfo "${myconf}"
		scons configure ${myconf} customCFlags="${CFLAGS}" || return 1 # "configure failed"
		scons ${MAKEOPTS} || return 1 # "scons failed"
		
		return 0
	}

	make_compile() {
		local myconf=""
		use nocxx || myconf="${myconf} --enable-cxx"		
		
		econf $(use_with alsa) $(use_with jack) \
			$(use_with oss)|| return 1 #die "econf failed"
		emake || return 1 #die "emake failed"
		
		return 0
	}
	
	ewarn "using scons build system"
	scons_compile
	if [ $? == "1" ];then
		build_tool="auto"
		ewarn "scons failded trying autotools"
		make_compile || die "die configure/build"
	else
		build_tool="scons"
	fi

}

src_install() {
	if [ "${build_tool}" == "scons" ];then
		dodir /usr
		scons install DESTDIR="${D}/usr" || die "scons failed to install"
		use doc && dodoc docs/*
	else
#		if ! use ppc-macos;then
#			dolib lib/*
#			dosym /usr/$(get_libdir)/libportaudio.so.0.0.19 /usr/$(get_libdir)/libportaudio.so
#		else
#			dolib pa_mac_core/libportaudio.dylib
#		fi
		emake  DESTDIR="${D}" install || die "install failed"
		
		insinto /usr/include
		doins include/portaudio.h
		use doc && dodoc docs/*
	fi
	
	# FIXME dirty hack
	mv ${D}/usr/lib ${D}/usr/$(get_libdir)
	find ${S} -name libportaudio.a -exec cp {} ${D}/usr/$(get_libdir) \;

	dodir /usr/include/${PN}-${SLOT}
	mv ${D}/usr/include/portaudio.h ${D}/usr/include/${PN}-${SLOT}

	mv ${D}/usr/$(get_libdir)/libportaudio$(get_libname 2.0.0) ${D}/usr/$(get_libdir)/libportaudio-${SLOT}$(get_libname 2.0.0)
	mv ${D}/usr/$(get_libdir)/libportaudio.a ${D}/usr/$(get_libdir)/libportaudio-${SLOT}.a
	
	rm ${D}/usr/$(get_libdir)/libportaudio$(get_libname 2.0)
	rm ${D}/usr/$(get_libdir)/libportaudio$(get_libname 2)
	rm ${D}/usr/$(get_libdir)/libportaudio$(get_libname)		

	# Symlinks
	cd ${D}/usr/$(get_libdir)

	ln -s libportaudio-${SLOT}$(get_libname 2.0.0) libportaudio-${SLOT}$(get_libname 2.0)
	ln -s libportaudio-${SLOT}$(get_libname 2.0.0) libportaudio-${SLOT}$(get_libname 2)	
	ln -s libportaudio-${SLOT}$(get_libname 2.0.0) libportaudio-${SLOT}$(get_libname)

	ln -s libportaudio-${SLOT}$(get_libname 2.0.0) libportaudio$(get_libname 2)	

	# CXX libs fixing
	if ( ! use nocxx )
	then
	    rm ${D}/usr/$(get_libdir)/libportaudiocpp.so
	    rm ${D}/usr/$(get_libdir)/libportaudiocpp.so.0	

	    cd ${D}/usr/$(get_libdir)
	    ln -s libportaudiocpp$(get_libname 0.0.12) libportaudiocpp$(get_libname 0.0)
	    ln -s libportaudiocpp$(get_libname 0.0.12) libportaudiocpp$(get_libname 0)	
	    ln -s libportaudiocpp$(get_libname 0.0.12) libportaudiocpp$(get_libname)	
	fi
	
#	dosym /usr/$(get_libdir)/libportaudio-${SLOT}$(get_libname 2.0.0) /usr/$(get_libdir)/libportaudio-${SLOT}$(get_libname 2.0)
#	dosym /usr/$(get_libdir)/libportaudio-${SLOT}$(get_libname 2.0.0) /usr/$(get_libdir)/libportaudio-${SLOT}$(get_libname 2)	
#	dosym /usr/$(get_libdir)/libportaudio-${SLOT}$(get_libname 2.0.0) /usr/$(get_libdir)/libportaudio-${SLOT}$(get_libname)
	
#	dosym /usr/$(get_libdir)/libportaudio-${SLOT}$(get_libname 2.0.0) /usr/$(get_libdir)/libportaudio$(get_libname 2)	
	
#	mv ${D}/usr/$(get_libdir)/libportaudio.la ${D}/usr/$(get_libdir)/libportaudio-${SLOT}.la
#	dosed -i -e "s:libportaudio:libportaudio-${SLOT}:g" /usr/$(get_libdir)/libportaudio-${SLOT}.la
	

	if ( ! use nocxx )
	then
	
    	    # CXX headers fixing
	    cd "${D}"/usr/include/portaudiocpp
	    for i in *
	    do
		sed -i -e "s:portaudio.h:portaudio-2/portaudio.h:g" $i
	    done
	
	    cd ${S}
	    dosed -i -e "s:-lportaudio:-lportaudio-${SLOT}:g" \
		-e "s:${D}::g" \
		/usr/$(get_libdir)/pkgconfig/portaudio-2.0.pc
	
	    # FIXME Dirty hack for portaudiocpp.pc 
	    cd ${S}/bindings/cpp
	    cp portaudiocpp.pc.in portaudiocpp.pc
	    sed -i -e "s:@prefix@:/usr:g" \
		-e "s:@exec_prefix@:/usr:g" \
		-e "s:@libdir@:/usr/lib:g" \
		-e "s:@includedir@:/usr/include:g" \
		portaudiocpp.pc
	    insinto /usr/$(get_libdir)/pkgconfig
	    doins portaudiocpp.pc		
	fi
	
	cd ${S}
	dodoc LICENSE.txt README.txt V19-devel-readme.txt COMPILING.DARWIN
}

