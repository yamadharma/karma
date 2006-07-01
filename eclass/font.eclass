# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/font.eclass,v 1.17 2005/12/13 05:08:37 spyderous Exp $

# Author: foser <foser@gentoo.org>

# Font Eclass
#
# Eclass to make font installation more uniform

inherit eutils


#
# Variable declarations
#

FONT_SUFFIX=""	# Space delimited list of font suffixes to install

FONT_S="${S}" # Dir containing the fonts

DOCS="" # Docs to install

IUSE="X"

DEPEND="X? ( || ( x11-apps/mkfontdir virtual/x11 ) )
	media-libs/fontconfig"

FONTSDIR_ROOT=/usr/share/fonts

if [ -z "${FONT_SUPPLIER}" ]
    then
    FONT_SUPPLIER=public
fi

if [ -z "${FONT_BUNDLE}" ]
    then
    FONT_BUNDLE=${PN}
fi

#if [ -z "${FONT_FAMILY}" ]
#    then
#    FONT_FAMILY=${PN}
#fi

if [ -z "${FONTS_NAME_DIR}" ]
    then
    FONTS_NAME_DIR=${FONT_SUPPLIER}/${FONT_BUNDLE}/${FONT_FAMILY}
fi    


# arg1: font format
set_fontsdir ()
{
        local format=$1

	case ${format} in 
    	    ttf) 
		FONTSDIR=${FONTSDIR_ROOT}/truetype/${FONTS_NAME_DIR}
		;;
    	    afm|pfm|pfa|pfb) 
		FONTSDIR=${FONTSDIR_ROOT}/type1/${FONTS_NAME_DIR}
		;;
    	    pcf) 
		FONTSDIR=${FONTSDIR_ROOT}/pcf/${FONTS_NAME_DIR}
		;;
    	    bdf) 
		FONTSDIR=${FONTSDIR_ROOT}/bdf/${FONTS_NAME_DIR}
		;;
    	    *) 
		einfo "Fonts format ${format} does not known"
		;;
	esac

}
#
# Public functions
#

font_xfont_config() {

	# create Xfont files
	if use X ; then
		einfo "Creating fonts.scale & fonts.dir ..."
		mkfontscale "${D}${FONTSDIR}"
		mkfontdir \
			-e /usr/share/fonts/encodings \
			-e /usr/share/fonts/encodings/large \
			"${D}${FONTSDIR}"
		if [ -e "${FONT_S}/fonts.alias" ] ; then
			doins "${FONT_S}/fonts.alias"
		fi
	fi

}

font_xft_config() {

	# create fontconfig cache
	einfo "Creating fontconfig cache ..."
	# Mac OS X has fc-cache at /usr/X11R6/bin
	HOME="/root" fc-cache -f "${D}${FONTSDIR}"

}

#
# Public inheritable functions
#

font_src_install() {

	local suffix

	cd "${FONT_S}"

	for suffix in ${FONT_SUFFIX}; do
		set_fontsdir ${suffix}
		insinto "${FONTSDIR}"
		doins *.${suffix}
	done

	rm -f fonts.{dir,scale} encodings.dir

	font_xfont_config
	font_xft_config

	cd "${S}"
	# try to install some common docs
	DOCS="${DOCS} COPYRIGHT README NEWS"
	dodoc ${DOCS}

}

font_pkg_setup() {

	# make sure we get no colissions
	# setup is not the nicest place, but preinst doesn't cut it
	for suffix in ${FONT_SUFFIX}; do
		set_fontsdir ${suffix}
		rm "${FONTSDIR}/fonts.cache-1"
	done

}

font_pkg_postinst ()
{
	for suffix in ${FONT_SUFFIX}; do
		set_fontsdir ${suffix}
		rm "${FONTSDIR}/fonts.cache-1"
	done

	chkfontpath -q -a ${FONTSDIR}
	/etc/init.d/xfs restart
}

font_pkg_prerm () 
{
	for suffix in ${FONT_SUFFIX}; do
		set_fontsdir ${suffix}
		rm "${FONTSDIR}/fonts.cache-1"
	done

	chkfontpath -r ${FONTSDIR}
	/etc/init.d/xfs restart
}


EXPORT_FUNCTIONS src_install pkg_setup pkg_postinst
