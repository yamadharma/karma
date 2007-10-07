# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2

FONT_SUPPLIER="microsoft"

inherit fonts

IUSE="${IUSE}"

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
KEYWORDS="x86 amd64 sparc sparc64 ppc"

DEPEND="${DEPEND}
	app-arch/cabextract"

FONT_FORMAT="ttf"

mydoc="licen.txt"

src_unpack () 
{
    # Unpack the MS fonts
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
}

# Local Variables:
# mode: sh
# End:
