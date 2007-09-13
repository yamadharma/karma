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

FONT_PN="${PN}" # Last part of $FONTDIR

FONTDIR="/usr/share/fonts/${FONT_PN}" # this is where the fonts are installed

DOCS="" # Docs to install

IUSE="X"

DEPEND="X? ( x11-apps/mkfontdir )
		media-libs/fontconfig"

FONTPATH_DIR="/etc/X11/fontpath.d"

FONTDIR_ROOT="/usr/share/fonts"

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
set_FONTDIR ()
{
        local format=$1

	case ${format} in 
    	    ttf) 
		FONTDIR=${FONTDIR_ROOT}/truetype/${FONTS_NAME_DIR}
		;;
    	    otf) 
		FONTDIR=${FONTDIR_ROOT}/opentype/${FONTS_NAME_DIR}
		;;
    	    afm|pfm|pfa|pfb) 
		FONTDIR=${FONTDIR_ROOT}/type1/${FONTS_NAME_DIR}
		;;
    	    pcf*) 
		FONTDIR=${FONTDIR_ROOT}/pcf/${FONTS_NAME_DIR}
		;;
    	    bdf) 
		FONTDIR=${FONTDIR_ROOT}/bdf/${FONTS_NAME_DIR}
		;;
    	    *) 
#		einfo "Fonts format ${format} does not known"
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
		mkfontscale "${D}${FONTDIR}"
		mkfontdir \
			-e /usr/share/fonts/encodings \
			-e /usr/share/fonts/encodings/large \
			"${D}${FONTDIR}"
		if [ -e "${FONT_S}/fonts.alias" ] ; then
			doins "${FONT_S}/fonts.alias"
		fi
	fi

}

font_xft_config() {

	if ! has_version '>=media-libs/fontconfig-2.4'; then
		# create fontconfig cache
		einfo "Creating fontconfig cache ..."
		# Mac OS X has fc-cache at /usr/X11R6/bin
		HOME="/root" fc-cache -f "${D}${FONTDIR}"
	fi
}

font_fontconfig() {

	local conffile
	if has_version '>=media-libs/fontconfig-2.4'; then
		insinto /etc/fonts/conf.avail/
		for conffile in "${FONT_CONF}"; do
			[[ -e  "${FILESDIR}/${conffile}" ]] && doins "${FILESDIR}/${conffile}"
		done
	fi

}

font_fontpath_dir_config() {
	if use X 
	then
		einfo "Creating fontpath.d entry"
		dosym ${FONTDIR} ${FONTPATH_DIR}/`echo ${FONTDIR} | sed s:${FONTDIR_ROOT}/:: | sed s:^/*:: | sed s:/*$:: | sed s:/:_:g`
	fi
	
}

#
# Public inheritable functions
#

font_src_install() {
	set_FONTDIR
	local suffix

	cd "${FONT_S}"

	for suffix in ${FONT_SUFFIX}; do
		set_FONTDIR ${suffix}
		insinto "${FONTDIR}"
		doins *.${suffix}
	done

	rm -f fonts.{dir,scale} encodings.dir

	for suffix in ${FONT_SUFFIX}; do
		set_FONTDIR ${suffix}
		font_xfont_config
		font_xft_config
		font_fontconfig
		font_fontpath_dir_config
	done

	cd "${S}"
	# try to install some common docs
	DOCS="${DOCS} COPYRIGHT README NEWS"
	dodoc ${DOCS}

}

font_pkg_setup() {
	set_FONTDIR
	# make sure we get no colissions
	# setup is not the nicest place, but preinst doesn't cut it
	for suffix in ${FONT_SUFFIX}; do
		set_FONTDIR ${suffix}
		[[ -e "${FONTDIR}/fonts.cache-1" ]] && rm "${FONTDIR}/fonts.cache-1"
	done

}

font_pkg_postinst ()
{
	set_FONTDIR
	for suffix in ${FONT_SUFFIX}; do
		set_FONTDIR ${suffix}
		rm "${FONTDIR}/fonts.cache-1"
#		chkfontpath -q -a ${FONTDIR}
	done

#	/etc/init.d/xfs restart
}

font_pkg_prerm () 
{
	set_FONTDIR
	for suffix in ${FONT_SUFFIX}; do
		set_FONTDIR ${suffix}
		rm "${FONTDIR}/fonts.cache-1"
#		chkfontpath -r ${FONTDIR}
	done

#	/etc/init.d/xfs restart
}

font_pkg_postrm() {
	set_FONTDIR
	if has_version '>=media-libs/fontconfig-2.4'; then
		if [ ${ROOT} == "/" ]; then
			ebegin "Updating global fontcache"
			fc-cache -s
			eend $?
		fi
	fi

}

EXPORT_FUNCTIONS src_install pkg_setup pkg_postinst pkg_postrm
