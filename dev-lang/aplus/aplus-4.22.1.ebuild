# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator elisp-common

MY_PV=$(replace_version_separator 2 '-' ${PV})
MY_P=${PN}-fsf-${MY_PV}

PATCH_V=-4

DESCRIPTION="A+ is an array-oriented programming language"
HOMEPAGE="http://www.aplusdev.org"
# SRC_URI="http://www.aplusdev.org/Download/${MY_P}.tar.gz"
SRC_URI="mirror://debian/pool/main/a/aplus-fsf/aplus-fsf_${PV}.orig.tar.gz
	mirror://debian/pool/main/a/aplus-fsf/aplus-fsf_${PV}${PATCH_V}.diff.gz"


LICENSE="GPL"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~sparc x86"
IUSE="emacs"

RDEPEND=""
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}-fsf-${PV}

SITEFILE=50aplus-gentoo.el

pkg_setup() {

	# make sure we get no colissions
	# setup is not the nicest place, but preinst doesn't cut it
	for i in /usr/share/fonts/truetype/public/aplus /usr/share/fonts/pcf/public/aplus
	do
	    [[ -e "${i}/fonts.cache-1" ]] && rm -f "${i}/fonts.cache-1"
	done	    
}


src_unpack ()
{
	unpack ${A}
	cd ${S}
	epatch ${WORKDIR}/aplus-fsf_${PV}${PATCH_V}.diff
}

src_compile () 
{
	econf \
		|| die

	emake \
    	    || die

	if use emacs 
	    then
	    pushd src/lisp.1
	    elisp-compile *.el
	    popd
	fi
}

src_install () 
{
	make install \
	    DESTDIR=${D} \
	    contribdir=/usr/share/doc/${PF}/contrib \
	    scriptsdir=/usr/share/doc/${PF}/scripts \
	    appdefaultsdir=/etc/X11/app-defaults \
	    a_includedir=/usr/include/aplus \
	    TrueTypedir=/usr/share/fonts/truetype/public/aplus \
	    fonts_pcfdir=/usr/share/fonts/pcf/public/aplus \
	    fonts_bdfdir=/usr/share/fonts/pcf/public/aplus \
	    || die

#	    idapdir=/usr/$(get_libdir)/aplus \
#	    fsftestdir=/usr/$(get_libdir)/aplus \
#	    apterdir=/usr/$(get_libdir)/aplus \
#	    tdir=/usr/$(get_libdir)/aplus \
#	    diodir=/usr/$(get_libdir)/aplus \
#	    sdir=/usr/$(get_libdir)/aplus \


	
	cd ${D}/usr/share/fonts/pcf/public/aplus
	mkfontdir \
		-e /usr/share/fonts/encodings \
		-e /usr/share/fonts/encodings/large \
		${D}/usr/share/fonts/pcf/public/aplus
	cat Kapl.alias >> fonts.alias

	cd ${D}/usr/share/fonts/truetype/public/aplus
	mkfontscale ${D}/usr/share/fonts/truetype/public/aplus
	mkfontdir \
		-e /usr/share/fonts/encodings \
		-e /usr/share/fonts/encodings/large \
		${D}/usr/share/fonts/truetype/public/aplus
#	HOME="/root" fc-cache -f ${D}/usr/share/fonts/truetype/public/aplus

	cd ${S}	
	
	dobin ${FILESDIR}/a+term
	mv ${D}/etc/X11/app-defaults/XTerm ${D}/etc/X11/app-defaults/AplusTerm
	dosed -i -e "s:XTerm\*:\*:g" /etc/X11/app-defaults/AplusTerm
	
	rm -rf ${D}/usr/lisp.?
	
	if use emacs 
	    then
	    pushd "${S}"
	    elisp-install aplus src/lisp.1/*.{el,elc}
	    elisp-site-file-install "${FILESDIR}"/${SITEFILE}
	    popd
	fi
	
	dodoc ANNOUNCE AUTHORS ChangeLog INSTALL NEWS README
}

pkg_postinst () 
{
	use emacs && elisp-site-regen
	chkfontpath -q -a /usr/share/fonts/pcf/public/aplus
}

pkg_postrm () 
{
	use emacs && elisp-site-regen
	chkfontpath -r /usr/share/fonts/pcf/public/aplus
}
