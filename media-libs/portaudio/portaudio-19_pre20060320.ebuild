# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/portaudio/portaudio-18.1-r3.ebuild,v 1.4 2005/09/09 19:34:23 ranger Exp $

ECVS_CVS_COMMAND="cvs -q"
ECVS_SERVER="www.portaudio.com:/home/cvs"
ECVS_USER="anonymous"
ECVS_AUTH="pserver"
ECVS_MODULE="${PN}"
ECVS_CO_OPTS="-P -D ${PV/*_pre}"
ECVS_UP_OPTS="-dP -D ${PV/*_pre}"
ECVS_BRANCH="v19-devel"
ECVS_TOP_DIR="${DISTDIR}/cvs-src/www.portaudio.com/${ECVS_BRANCH}"

inherit eutils cvs

DESCRIPTION="An open-source cross platform audio API."
HOMEPAGE="http://www.portaudio.com"
#SRC_URI="http://www.portaudio.com/archives/${MY_P}.zip"

LICENSE="GPL-2"
SLOT="19"
KEYWORDS="amd64 ~hppa ~mips ~ppc ~ppc-macos ~ppc64 ~sparc x86"
IUSE="oss alsa jack doc"

DEPEND="alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )"

RDEPEND="virtual/libc
	${DEPEND}"

S=${WORKDIR}/${ECVS_MODULE}
# S=${WORKDIR}/${MY_P}

src_compile () 
{
	myconf="$(use_with alsa) $(use_with oss) $(use_with jack)"
	econf ${myconf} || die "configure failed"
	emake || die "make failed"
}

src_install () 
{
	insinto /usr/include/${PN}-${SLOT}
	doins pa_common/portaudio.h

	dolib.so lib/libportaudio.so.0.0.19
	dolib.a lib/libportaudio.a 
	
	mv ${D}/usr/$(get_libdir)/libportaudio.so.0.0.19 ${D}/usr/$(get_libdir)/libportaudio-19.so.0.0.19
	mv ${D}/usr/$(get_libdir)/libportaudio.a ${D}/usr/$(get_libdir)/libportaudio-19.a
	
	dosym /usr/$(get_libdir)/libportaudio-19.so.0.0.19 /usr/$(get_libdir)/libportaudio-19.so.0
	dosym /usr/$(get_libdir)/libportaudio-19.so.0.0.19 /usr/$(get_libdir)/libportaudio-19.so
	
	dodoc LICENSE.txt README.txt V19-devel-readme.txt
	if use doc
	    then 
	    dodoc docs/*.txt
	    dodoc docs/*.pdf
	    dohtml docs/*
	fi
}
