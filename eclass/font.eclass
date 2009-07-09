# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Font Eclass
#
# Eclass to make font installation more uniform

inherit eutils 

#
# Variable declarations
#

# @ECLASS-VARIABLE: FONT_SUFFIX
# @DESCRIPTION:
# Space delimited list of font suffixes to install
FONT_SUFFIX=""

# @ECLASS-VARIABLE: FONT_S
# @DESCRIPTION:
# Dir containing the fonts
FONT_S=${S}

# @ECLASS-VARIABLE: FONT_PN
# @DESCRIPTION:
# Last part of $FONTDIR
FONT_PN=${PN}

# @ECLASS-VARIABLE: FONTDIR
# @DESCRIPTION:
# This is where the fonts are installed
FONTDIR=/usr/share/fonts/${FONT_PN}

# @ECLASS-VARIABLE: FONT_CONF
# @DESCRIPTION:
# Array, which element(s) is(are) path(s) of fontconfig-2.4 file(s) to install
FONT_CONF=( "" )

# @ECLASS-VARIABLE: DOCS
# @DESCRIPTION:
# Docs to install
DOCS="" 

# @ECLASS-VARIABLE: NFONT_SUFFIX
# @DESCRIPTION:
# Space delimited list of font suffixes to install for GNUstep
NFONT_SUFFIX=""


IUSE="gnustep X"

DEPEND="X? ( x11-apps/mkfontdir
			media-fonts/encodings )
	gnustep? ( >=gnustep-base/mknfonts-0.5-r1 )
		media-libs/fontconfig"

# Where to install GNUstep
GNUSTEP_PREFIX="/usr/GNUstep"

FONTPATH_DIR="/etc/X11/fontpath.d"

FONTDIR_ROOT="/usr/share/fonts"

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
		;;
	esac
}

#
# Public functions
#

# @FUNCTION: font_xfont_config
# @DESCRIPTION:
# Creates the Xfont files.
font_xfont_config() {
	# create Xfont files
	if use X ; then
		einfo "Creating fonts.scale & fonts.dir ..."
		rm -f "${D}${FONTDIR}"/fonts.{dir,scale}
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

# @FUNCTION: font_xft_config
# @DESCRIPTION:
# Creates the fontconfig cache if necessary.
font_xft_config() {
	if ! has_version '>=media-libs/fontconfig-2.4'; then
		# create fontconfig cache
		einfo "Creating fontconfig cache ..."
		fc-cache -sf "${D}${FONTDIR}"
	fi
}

# @FUNCTION: font_fontconfig
# @DESCRIPTION:
# Installs the fontconfig config files of FONT_CONF.
font_fontconfig() {
	local conffile
	if [[ -n ${FONT_CONF[@]} ]]; then
		if has_version '>=media-libs/fontconfig-2.4'; then
			insinto /etc/fonts/conf.avail/
			for conffile in "${FONT_CONF[@]}"; do
				[[ -e  ${conffile} ]] && doins ${conffile}
			done
		fi
	fi
}

font_fontpath_dir_config() {
	if ( use X )
	then
		einfo "Creating fontpath.d entry"
		dosym ${FONTDIR} ${FONTPATH_DIR}/`echo ${FONTDIR} | sed s:${FONTDIR_ROOT}/:: | sed s:^/*:: | sed s:/*$:: | sed s:/:_:g`
	fi
	
}

font_make_nfont() {
	if [[ -z ${NFONT_SUFFIX} ]]
	then
		NFONT_SUFFIX=${FONT_SUFFIX}
	fi
	if ( use gnustep )
	then
		# Get additional variables
		GNUSTEP_SH_EXPORT_ALL_VARIABLES="true"

		if [ -f ${GNUSTEP_PREFIX}/System/Library/Makefiles/GNUstep.sh ] 
		then
			# Reset GNUstep variables
			source "${GNUSTEP_PREFIX}"/System/Library/Makefiles/GNUstep-reset.sh
			source "${GNUSTEP_PREFIX}"/System/Library/Makefiles/GNUstep.sh
		fi
		
		einfo "Generating nfonts support files"
		dodir "${GNUSTEP_PREFIX}"/System/Library/Fonts
		cd ${D}"${GNUSTEP_PREFIX}"/System/Library/Fonts
		for suffix in ${NFONT_SUFFIX}; do
			set_FONTDIR ${suffix}
			insinto "${FONTDIR}"
			${GNUSTEP_SYSTEM_TOOLS}/mknfonts \
			    ${D}"${FONTDIR}"/* \
			    || die "nfonts support files creation failed"
		done
		
		# Trim whitepsaces
#		for fdir in *\ */; do
#			mv "$fdir" `echo $fdir | tr -d [:space:]`
#		done
		
		# Remove DESTDIR
		find . -name "*.plist" -exec sed -ie "s:${D}::g" {} \;
		find . -name "*.plist" -exec sed -ie "s://:/:g" {} \;
		find . -name "*.pliste" -exec rm {} \;
	fi
}

# "
#
# Public inheritable functions
#


# @FUNCTION: font_src_install
# @DESCRIPTION:
# The font src_install function, which is exported.
font_src_install() {
	set_FONTDIR
	local suffix commondoc

	cd "${FONT_S}"

	for suffix in ${FONT_SUFFIX}; do
		set_FONTDIR ${suffix}
		insinto "${FONTDIR}"
		doins *.${suffix}
	done

	rm -f fonts.{dir,scale} encodings.dir

	if [[ -z ${FONT_SUFFIX} ]]
	then
		font_xfont_config
		font_xft_config
		font_fontconfig
		font_fontpath_dir_config
		font_make_nfont
	else
		for suffix in ${FONT_SUFFIX}
		do
			set_FONTDIR ${suffix}
			font_xfont_config
			font_xft_config
			font_fontconfig
			font_fontpath_dir_config
			font_make_nfont
		done
	fi

	cd "${S}"
	dodoc ${DOCS} 2> /dev/null

	# install common docs
	for commondoc in COPYRIGHT README NEWS AUTHORS BUGS ChangeLog; do
		[[ -s ${commondoc} ]] && dodoc ${commondoc}
	done
}

# @FUNCTION: font_pkg_setup
# @DESCRIPTION:
# The font pkg_setup function, which is exported.
font_pkg_setup() {

#	FONT_S=${S}

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
	# unreadable font files = fontconfig segfaults
	find "${ROOT}"usr/share/fonts/ -type f '!' -perm 0644 -print0 \
		| xargs -0 chmod -v 0644 2>/dev/null

	if has_version '>=media-libs/fontconfig-2.4'; then
		if [ ${ROOT} == "/" ]; then
			ebegin "Updating global fontcache"
			fc-cache -fs
			eend $?
		fi
	fi
}

font_pkg_postrm() {
	# unreadable font files = fontconfig segfaults
	find "${ROOT}"usr/share/fonts/ -type f '!' -perm 0644 -print0 \
		| xargs -0 chmod -v 0644 2>/dev/null

	if has_version '>=media-libs/fontconfig-2.4'; then
		if [ ${ROOT} == "/" ]; then
			ebegin "Updating global fontcache"
			fc-cache -fs
			eend $?
		fi
	fi
}

EXPORT_FUNCTIONS src_install pkg_setup pkg_postinst pkg_postrm
