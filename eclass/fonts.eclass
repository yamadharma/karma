# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# Author Matthew Kennedy <mkennedy@gentoo.org>
# $Header: $

ECLASS=fonts
INHERITED="$INHERITED $ECLASS"

inherit patch extrafiles

EXPORT_FUNCTIONS pkg_postinst pkg_prerm pkg_postrm src_unpack src_compile src_install

#EXPORT_FUNCTIONS pkg_setup pkg_preinst pkg_postinst pkg_prerm pkg_postrm \
#	src_compile src_install src_test \
#	perlinfo updatepod

IUSE="${IUSE} X gnustep"

DEPEND="${DEPEND}
	gnustep? gnustep-base/gnustep-env
	X? media-fonts/chkfontpath"

for format in ${FONT_FORMAT}
  do
  case ${format} in
      ttf) 
	  DEPEND="${DEPEND}
	>=x11-misc/ttmkfdir-2.0"
	  RDEPEND="${RDEPEND}
	>=x11-misc/ttmkfdir-2.0"
	  ;;
      type1) 
	  ;;
      psf) 
	  ;;
      pcf|bdf2pcf) 
	  ;;
      bdf) 
	  ;;
      *) 
	  einfo "Fonts format ${1} does not known"
	  ;;
  esac
done

nfont_base=${FILESDIR}/extra/fonts/gnustep

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

if [ -z "${INSTALL_TARGET}" ]
    then
    INSTALL_TARGET="x"
fi    

X_FONTSDIR=""
FONT_VARIANT=""

#FONT_FORMAT=""
#XFS_ADD_FIRST=

FONTSDIR_ROOT=/usr/share/fonts
TTF_FONTSDIR_ROOT=${FONTSDIR_ROOT}/truetype

TYPE1_FONTSDIR_ROOT=${FONTSDIR_ROOT}/type1
AFM_FONTSDIR_ROOT=${FONTSDIR_ROOT}/type1
#AFM_FONTSDIR_ROOT=${FONTSDIR_ROOT}/afm

PCF_FONTSDIR_ROOT=${FONTSDIR_ROOT}/pcf
BDF_FONTSDIR_ROOT=${FONTSDIR_ROOT}/bdf

PSF_FONTSDIR_ROOT=/usr/share/consolefonts
PSF_FONTSDIR=${PSF_FONTSDIR_ROOT}

TTF_FONTSDIR=${TTF_FONTSDIR_ROOT}/${FONTS_NAME_DIR}
PCF_FONTSDIR=${PCF_FONTSDIR_ROOT}/${FONTS_NAME_DIR}
BDF_FONTSDIR=${BDF_FONTSDIR_ROOT}/${FONTS_NAME_DIR}

TYPE1_FONTSDIR=${TYPE1_FONTSDIR_ROOT}/${FONTS_NAME_DIR}
AFM_FONTSDIR=${AFM_FONTSDIR_ROOT}/${FONTS_NAME_DIR}

# {{{ Remove duble slash

TTF_FONTSDIR=${TTF_FONTSDIR/\/\//\/}
PCF_FONTSDIR=${PCF_FONTSDIR/\/\//\/}
BDF_FONTSDIR=${BDF_FONTSDIR/\/\//\/}

TYPE1_FONTSDIR=${TYPE1_FONTSDIR/\/\//\/}
AFM_FONTSDIR=${AFM_FONTSDIR/\/\//\/}

# }}}

X_FONTSDIR="${X_FONTSDIR} ${PCF_FONTSDIR}"

if [ -z "${S_FONTS}" ]
    then
    S_FONTS=""
fi

FONTSDIRS=""

for format in ${FONT_FORMAT}
  do
  case ${format} in
      ttf) 
	  FONTSDIRS="${FONTSDIRS} ${TTF_FONTSDIR}"
	  ;;
      type1) 
	  FONTSDIRS="${FONTSDIRS} ${TYPE1_FONTSDIR} ${AFM_FONTSDIR} ${PFM_FONTSDIR}"
	  ;;
      psf) 
	  FONTSDIRS="${FONTSDIRS} ${PSF_FONTSDIR}"
	  ;;
      pcf|bdf2pcf) 
	  FONTSDIRS="${FONTSDIRS} ${PCF_FONTSDIR}"
	  ;;
      bdf) 
	  FONTSDIRS="${FONTSDIRS} ${BDF_FONTSDIR}"
	  ;;
      *) 
	  einfo "Fonts format ${1} does not known"
	  ;;
  esac
done

# arg1: 
#	ttf : truetype font specific
#	x   : X11 standard
fonts_xfont_config () 
{

# ********************************************************************
#  A note about fonts and needed files:
#  
#  1)  Create /usr/X11R6/lib/X11/fonts/encodings/encodings.dir
#
#  2)  Create font.scale for TrueType fonts (need to do this before
#      we create fonts.dir files, else fonts.dir files will be
#      invalid for TrueType fonts...)
#
#  3)  Now Generate fonts.dir files.
#
#  CID fonts is a bit more involved, but as we do not install any,
#  I am not going to bother.
# ********************************************************************
    local i
    local encdirs=""
    local scaleproc="/usr/X11R6/bin/mkfontscale"
    
    case "$i" in
	ttf)
	    scaleproc="/usr/X11R6/bin/ttmkfdir"
	    ;;
	x|*)
	    scaleproc="/usr/X11R6/bin/mkfontscale"
	    ;;
    esac
    
    for i in /usr/share/fonts/encodings /usr/share/fonts/encodings/large /usr/X11R6/lib/X11/fonts/encodings /usr/X11R6/lib/X11/fonts/encodings/large
      do
      if [ -e "${i}/encodings.dir" ]
	  then
	  encdirs="${encdirs} -e ${i}"
      fi
    done
    
    einfo "Generating encodings.dir..."
    # Create the encodings.dir
    LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${ROOT}/usr/X11R6/lib" \
	${ROOT}/usr/X11R6/bin/mkfontdir -n \
	${encdirs}
#	 -- ${D}${TTF_FONTSDIR}
	      
    einfo "Creating fonts.scale files..."
    LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${ROOT}/usr/X11R6/lib" \
	${scaleproc} \
	${encdirs}
#		  -e ./encodings.dir
#		  -d ${D}${TTF_FONTSDIR}
	      
    einfo "Generating fonts.dir files..."
    LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${ROOT}/usr/X11R6/lib" \
	${ROOT}/usr/X11R6/bin/mkfontdir \
	${encdirs} 
#		  -- ${D}${TTF_FONTSDIR}


#
#	# create Xfont files
#	if [ -n "`use X`" ] ;
#	then
#		einfo "Creating fonts.scale & fonts.dir..."
#		mkfontscale ${D}/usr/share/fonts/${PN}
#		mkfontdir \
#			-e /usr/share/fonts/encodings \
#			-e /usr/share/fonts/encodings/large \
#			-e /usr/X11R6/lib/X11/fonts/encodings \
#			${D}/usr/share/fonts/${PN}
#		if [ -e ${FONT_S}/fonts.alias ] ;
#		then
#			doins ${FONT_S}/fonts.alias
#		fi
#	fi
#
}

# arg1: font format
# arg2: list of font files	
fonts_install () 
{
    local fntformat=$1    

    FONTC=""
        
    case "$1" in
	ttf) 
	    FONT_EXT=ttf
	    CURFONTSDIR=${TTF_FONTSDIR}
	    GZIP_FONTS=0
	    ;;
	pfa|pfb) 
	    FONT_EXT=pfb
	    CURFONTSDIR=${TYPE1_FONTSDIR}
	    GZIP_FONTS=0
	    ;;
	afm|pfm) 
	    FONT_EXT=afm
	    CURFONTSDIR=${AFM_FONTSDIR}
	    GZIP_FONTS=0
	    ;;
	psf) 
	    FONT_EXT=psf
	    CURFONTSDIR=${PSF_FONTSDIR}
	    GZIP_FONTS=1
	    ;;
	pcf) 
	    FONT_EXT=pcf
	    CURFONTSDIR=${PCF_FONTSDIR}
	    GZIP_FONTS=1
	    X_FONTSDIR="${X_FONTSDIR} ${CURFONTSDIR}"
	    ;;
	bdf) 
	    FONT_EXT=bdf
	    CURFONTSDIR=${BDF_FONTSDIR}
	    GZIP_FONTS=0
	    X_FONTSDIR="${X_FONTSDIR} ${CURFONTSDIR}"
#	    FONTC=bdftopcf
#	    FONTCFLAGS=
#	    TARGET_FONT_EXT=bdf
	    ;;
	bdf2pcf) 
	    FONT_EXT=bdf
	    CURFONTSDIR=${PCF_FONTSDIR}
	    GZIP_FONTS=1
	    X_FONTSDIR="${X_FONTSDIR} ${CURFONTSDIR}"
	    FONTC=bdftopcf
	    FONTCFLAGS=
	    TARGET_FONT_EXT=pcf
	    ;;
	*) 
	    einfo "Fonts format ${1} does not known"
	    ;;
    esac
  
    shift

    if [ ! -d "${D}/${CURFONTSDIR}" ] ; 
	then
	install -d "${D}/${CURFONTSDIR}"
    fi
    
    for x in "$@" 
      do
      if [ "${fntformat}" = "bdf2pcf" ]
	  then
	  if [ -e "${x}" ]  
	      then
	      ${FONTC} ${FONTCFLAGS} ${x} -o `basename ${x} .${FONT_EXT}`.${TARGET_FONT_EXT}
	      y=`basename ${x} .${FONT_EXT}`.${TARGET_FONT_EXT}
	      if [ ${GZIP_FONTS} = 1 ] 
		  then
		  gzip -q ${y} 
		  y=${y}.gz
	      fi
	      install -m644 "${y}" "${D}/${CURFONTSDIR}"
	  fi    
	  elif [ -e "${x}" ]  
	  then
	  y=${x}
	  if [ ${GZIP_FONTS} = 1 ] 
	      then
	      gzip -q ${x}
	      y=${x}.gz
	  fi
	  install -m644 "${y}" "${D}/${CURFONTSDIR}"
      else
	  echo "${0}: ${x} does not exist"
      fi
    done

}

fonts_src_compile ()
{
    einfo "Nothing to compile"
}

fonts_src_install ()
{
    local format
    local i
    local j
    local fullname
    local s_fonts_list
    
    for format in ${FONT_FORMAT}
      do
      case ${format} in
	  ttf) 
	      cd ${S}/${S_FONTS}
	      fonts_install ttf *.ttf
	      
	      cd ${D}${TTF_FONTSDIR}	
	      fonts_xfont_config ttf
	      cd ${S}
	      ;;
	  type1) 
	      cd ${S}/${S_FONTS}
	      fonts_install afm *.afm
	      fonts_install pfm *.pfm
	      fonts_install pfb *.pfb

	      cd ${D}${TYPE1_FONTSDIR}
	      fonts_xfont_config x
	      cd ${S}
	      ;;
	  psf) 
	      FONT_TYPE=psf
	      CURFONTSDIR=${PSF_FONTSDIR}
	      GZIP_FONTS=1
	      ;;
	  pcf) 
#	      for i in ${S_FONTS}      
#		do
#		cd ${S}/${i}
	        cd ${S}/${S_FONTS}   
		fonts_install pcf *.pcf
		if [ -f fonts.alias ]
		    then
		    cat fonts.alias >> ${D}/${PCF_FONTSDIR}/fonts.alias				
		fi
#	      done
	      
	      cd ${D}/${PCF_FONTSDIR}
	      fonts_xfont_config x
	      cd ${S}
	      ;;
	  bdf2pcf)
	      if [ -n "${S_FONTS_bdf2pcf}" ]
	        then
		s_fonts_list=${S_FONTS_bdf2pcf}
	      elif [ -n "${S_FONTS}" ]
	        then
	        s_fonts_list=${S_FONTS}
	      else 		
	        s_fonts_list="./"
	      fi	 
	      for i in ${s_fonts_list}      
		do
		cd ${S}/${i}
#		cd ${S}/${S_FONTS}   
		fonts_install bdf2pcf *.bdf
		if [ -f fonts.alias ]
		    then
		    cat fonts.alias >> ${D}/${PCF_FONTSDIR}/fonts.alias				
		fi		    
	      done
	      
	      cd ${D}/${PCF_FONTSDIR}
	      fonts_xfont_config x
	      cd ${S}
	      ;;
	  bdf) 
#	      for i in ${S_FONTS}      
#		do
#		cd ${S}/${i}
		cd ${S}/${S_FONTS}   
		fonts_install bdf *.bdf
		if [ -f fonts.alias ]
		    then
		    cat fonts.alias >> ${D}/${BDF_FONTSDIR}/fonts.alias				
		fi
#	      done
	      
	      cd ${D}/${BDF_FONTSDIR}
	      fonts_xfont_config x
	      cd ${S}
	      ;;

	  *) 
	      echo "Fonts format ${1} does not known"
	      ;;
      esac
    done
    
    if ( use gnustep )
	then
	install_gnustep_nfont
    fi
    
    if [ ! -z "${mydoc}" ]
	then
	cd ${S}
	dodoc ${mydoc}
    fi
    
}

install_gnustep_nfont () 
{
    if [ -z "${PR}" ]
	then
	my_rev=r0
    else
	my_rev=${PR}
    fi
    
    if [ -d ${nfont_base}/version ]
	then
	cd ${nfont_base}/version
	if [ -d ${PV}-${my_rev} ]
	    then
	    fonts_extra_gnustep_install ${nfont_base}/version/${PV}-${my_rev}
	    return 0
	elif [ -d ${PV} ]
	    then
	    fonts_extra_gnustep_install ${nfont_base}/version/${PV}
	    return 0
	fi
    fi
    
    if [ -d ${nfont_base}/majorversion ]
	then
	cd ${nfont_base}/majorversion
	for majorversion in ${mv_list}
	  do
	  if [ -d ${majorversion} ]
	      then
	      fonts_extra_gnustep_install ${nfont_base}/majorversion/${majorversion}
	      return 0
	  fi
	done
    fi
}

# arg1: nfont file directory
fonts_extra_gnustep_install ()
{
    local nfontfile=$1/nfont.tar.bz2
    
    source /etc/conf.d/gnustep.env
    
    if [ -f ${GNUSTEP_SYSTEM_ROOT}/Library/Makefiles/GNUstep.sh ] 
	then
	source ${GNUSTEP_SYSTEM_ROOT}/Library/Makefiles/GNUstep.sh
    else
	die "gnustep-make not installed!"
    fi
    
    dodir ${GNUSTEP_SYSTEM_ROOT}/Library/Fonts
    cd ${D}${GNUSTEP_SYSTEM_ROOT}/Library/Fonts
    tar xjf ${nfontfile}
    
    cd ${D}${GNUSTEP_SYSTEM_ROOT}/Library/Fonts
    for i in *.sym
      do
      while read j
	do
	fullname=`find ${D}${FONTSDIR_ROOT} -name ${j} -print`
	fullname=`echo ${fullname} | sed -e "s:${D}::"`
	dosym "${fullname}" "${GNUSTEP_SYSTEM_ROOT}/Library/Fonts/`basename "${i}" .sym`/${j}"
      done  < "${i}"
      rm -f "${i}"
    done
    
}

fonts_pkg_postinst () 
{
    local format
    
    if [ -n "${XFS_ADD_FIRST}" ]
	then
	CHKFONTPATH_OPTIONS="--first"
	else
	CHKFONTPATH_OPTIONS=""
    fi
    
    for format in ${FONT_FORMAT}
      do
      case "${format}" in
	  ttf) 
	      if ( use X )
		  then	
		  /usr/bin/chkfontpath -q ${CHKFONTPATH_OPTIONS} -a ${TTF_FONTSDIR}
		  /etc/init.d/xfs restart
	      fi
	      ;;
	  type1)
	      if ( use X )
		  then	
		  /usr/bin/chkfontpath -q ${CHKFONTPATH_OPTIONS} -a ${TYPE1_FONTSDIR}
		  /etc/init.d/xfs restart
	      fi
	      ;;    	      
	  psf) 
	      ;;
	  pcf|bdf) 
	      if ( use X )
		  then	
		  /usr/bin/chkfontpath -q ${CHKFONTPATH_OPTIONS} -a ${PCF_FONTSDIR}
		  /etc/init.d/xfs restart
	      fi
	      ;;
	  *) 
	      echo "Fonts format ${format} does not known"
	      ;;
      esac
    done    
    
    fc-cache
}


fonts_pkg_prerm () 
{
    local dir

    for format in ${FONT_FORMAT}
      do
      case ${format} in
	  ttf) 
	      cd ${TTF_FONTSDIR}
	      rm -f fonts.cache-1 fonts.list
	      if ( use X )
		  then	
		  /usr/bin/chkfontpath -r ${TTF_FONTSDIR}
		  /etc/init.d/xfs restart
	      fi
	      ;;
	  type1) 
	      cd ${TYPE1_FONTSDIR}
	      rm -f fonts.cache-1 fonts.list
	      if ( use X )
		  then	
		  /usr/bin/chkfontpath -r ${TTF_FONTSDIR}
		  /etc/init.d/xfs restart
	      fi
	      ;;
	  psf) 
	      ;;
	  pcf|bdf|bdf2pcf) 
	      cd ${PCF_FONTSDIR}
	      rm -f fonts.cache-1 fonts.list
	      if ( use X )
		  then	
		  /usr/bin/chkfontpath -r ${PCF_FONTSDIR}
		  /etc/init.d/xfs restart
	      fi
	      ;;
	  *) 
	      echo "Fonts format ${1} does not known"
	      ;;
      esac
    done
}

fonts_pkg_postrm () 
{
    fc-cache
}

fonts_src_unpack ()
{
    patch_src_unpack
}

# Local Variables:
# mode: sh
# End:
