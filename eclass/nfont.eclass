# Copyright 1999-2006 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ECLASS=nfont
INHERITED="$INHERITED $ECLASS"

inherit gnustep-funcs

IUSE="gnustep"

if [ -z "$NFONT" ]
    then
    NFONT=${PN}.nfont.tar.bz2
fi

# arg1: nfont file directory
nfont_src_install ()
{
    egnustep_env
    
    local nfontfile=${FILESDIR}/${NFONT}
    
    dodir ${GNUSTEP_SYSTEM_ROOT}/Library/Fonts
    cd ${D}${GNUSTEP_SYSTEM_ROOT}/Library/Fonts
    tar xjf ${nfontfile}
    
    cd ${D}${GNUSTEP_SYSTEM_ROOT}/Library/Fonts
    for i in *.list
      do
      while read j
	do
	fullname=`find ${D}${FONTSDIR_ROOT} -name ${j} -print`
	fullname=`echo ${fullname} | sed -e "s:${D}::"`
	dosym "/${fullname}" "${GNUSTEP_SYSTEM_ROOT}/Library/Fonts/`basename "${i}" .list`/${j}"
      done  < "${i}"
      rm -f "${i}"
    done
}

# Local Variables:
# mode: sh
# End:
