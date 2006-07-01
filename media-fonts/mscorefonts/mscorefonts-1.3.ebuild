# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2

IUSE=""

S=${WORKDIR}/truetype
DESCRIPTION="Microsoft's TrueType core fonts"
HOMEPAGE="http://corefonts.sf.net"

# Need windows license to use this one
MS_COREFONTS="./andale32.exe 
  ./arial32.exe
  ./arialb32.exe 
  ./comic32.exe
  ./courie32.exe 
  ./georgi32.exe
  ./impact32.exe 
  ./times32.exe
  ./trebuc32.exe 
  ./verdan32.exe
  ./webdin32.exe"
#	./IELPKTH.CAB"

SRC_URI="${MS_COREFONTS//\.\//mirror://sourceforge/corefonts/}"

LICENSE="X11 MSttfEULA"
SLOT="0"
KEYWORDS="x86 sparc sparc64 ppc"

DEPEND=">=x11-misc/ttmkfdir-2.0
	app-arch/cabextract"
	
RDEPEND=">=x11-misc/ttmkfdir-2.0"

src_unpack() 
{
  # Unpack the MS fonts
  if [ -n "`use truetype`" ]
  then
    einfo "Unpacking MS Core Fonts..."
    mkdir -p ${S}; cd ${S}
    for x in ${MS_COREFONTS}
    do
      if [ -f ${DISTDIR}/${x} ]
      then
	einfo "  ${x/\.\/}..."
	cabextract --lowercase ${DISTDIR}/${x} > /dev/null || die
      fi
    done
  fi
}

src_install() {

  # Install MS fonts.
  einfo "Installing MS Core Fonts..."
  dodir /usr/share/fonts/ttf/microsoft
  mv -f ${S}/*.ttf ${D}/usr/share/fonts/ttf/microsoft
  
  cd ${S}
  dodoc licen.txt
}


pkg_postinst() 
{

#  if [ "${ROOT}" = "/" ]
#  then
    umask 022

  einfo "Creating FC font cache..."
  ${ROOT}/usr/bin/fc-cache

  # This one cause ttmkfdir to segfault :/
  rm -f ${ROOT}/usr/X11R6/lib/X11/fonts/encodings/large/gbk-0.enc.gz

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
  #
  #  <azarah@gentoo.org> (20 Oct 2002)
  #
  # ********************************************************************

  einfo "Generating encodings.dir..."
  # Create the encodings.dir in /usr/X11R6/lib/X11/fonts/encodings
  LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${ROOT}/usr/X11R6/lib" \
    ${ROOT}/usr/X11R6/bin/mkfontdir -n \
    -e ${ROOT}/usr/X11R6/lib/X11/fonts/encodings \
    -e ${ROOT}/usr/X11R6/lib/X11/fonts/encodings/large \
    -- ${ROOT}/usr/X11R6/lib/X11/fonts/encodings

  einfo "Creating fonts.scale files..."
  for x in $(find ${ROOT}/usr/X11R6/lib/X11/fonts/* -type d -maxdepth 1)
  do
    [ -z "$(ls ${x}/)" ] && continue
    [ "$(ls ${x}/)" = "fonts.cache-1" ] && continue
		
    # Only generate .scale files if there are truetype
    # fonts present ...
    if [ "${x/encodings}" = "${x}" -a \
      -n "$(find ${x} -name '*.tt[cf]' -print)" ]
    then
      ${ROOT}/usr/X11R6/bin/ttmkfdir \
      -e ${ROOT}/usr/X11R6/lib/X11/fonts/encodings/encodings.dir \
      -o ${x}/fonts.scale -d ${x}
    fi
  done
			
  einfo "Generating fonts.dir files..."
  for x in $(find ${ROOT}/usr/X11R6/lib/X11/fonts/* -type d -maxdepth 1)
  do
    [ -z "$(ls ${x}/)" ] && continue
    [ "$(ls ${x}/)" = "fonts.cache-1" ] && continue
		
    if [ "${x/encodings}" = "${x}" ]
    then
      LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${ROOT}/usr/X11R6/lib" \
      ${ROOT}/usr/X11R6/bin/mkfontdir \
       -e ${ROOT}/usr/X11R6/lib/X11/fonts/encodings \
       -e ${ROOT}/usr/X11R6/lib/X11/fonts/encodings/large \
       -- ${x}
    fi
  done

  einfo "Fixing permissions..."
  find ${ROOT}/usr/X11R6/lib/X11/fonts/ -type f -name 'font.*' \
    -exec chmod 0644 {} \;


}

