# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit font

IUSE="${IUSE}"

DESCRIPTION="CYRillic Raster Fonts for X"
HOMEPAGE="http://www.inp.nsk.su/~bolkhov/files/fonts/cyr-rfx/00index.en.html"
SRC_URI="http://www.inp.nsk.su/~bolkhov/files/fonts/cyr-rfx/srctgz/${PN}-koi8-1-${PV}.bdfs.tgz
	http://www.inp.nsk.su/~bolkhov/files/fonts/cyr-rfx/srctgz/${PN}-windows-1251-${PV}.bdfs.tgz
	http://www.inp.nsk.su/~bolkhov/files/fonts/cyr-rfx/srctgz/${PN}-iso10646-0400-${PV}.bdfs.tgz"
#	http://www.inp.nsk.su/~bolkhov/files/fonts/cyr-rfx/${PN}-koi8-ru-${PV}.tgz
#	http://www.inp.nsk.su/~bolkhov/files/fonts/cyr-rfx/${PN}-iso8859-5-${PV}.tgz
#	http://www.inp.nsk.su/~bolkhov/files/fonts/cyr-rfx/${PN}-koi8-ub-${PV}.tgz
#	http://www.inp.nsk.su/~bolkhov/files/fonts/cyr-rfx/${PN}-koi8-o-${PV}.tgz
#	http://www.inp.nsk.su/~bolkhov/files/fonts/cyr-rfx/${PN}-ibm-cp866-${PV}.tgz
#	http://www.inp.nsk.su/~bolkhov/files/fonts/cyr-rfx/${PN}-bulgarian-mik-${PV}.tgz
#	http://www.inp.nsk.su/~bolkhov/files/fonts/cyr-rfx/${PN}-winlatin-1-${PV}.tgz
#	http://www.inp.nsk.su/~bolkhov/files/fonts/cyr-rfx/${PN}-iso8859-15-${PV}.tgz"

LICENSE="AS IS"
SLOT="0"
KEYWORDS="x86 amd64 ~sparc ~sparc64 ~ppc"

S=${WORKDIR}

S_FONTS="
koi8-1/misc
koi8-1/75dpi 
windows-1251/misc 
windows-1251/75dpi 
iso10646-0400/misc 
iso10646-0400/75dpi
"
#koi8-ru/misc
#koi8-ru/75dpi
#iso8859-5/misc
#iso8859-5/75dpi
#koi8-ub/misc
#koi8-ub/75dpi
#koi8-o/misc
#koi8-o/75dpi
#ibm-cp866/misc
#ibm-cp866/75dpi
#bulgarian-mik/misc
#bulgarian-mik/75dpi
#iso10646-0400/misc
#iso10646-0400/75dpi
#winlatin-1/misc
#winlatin-1/75dpi
#iso8859-15/misc
#iso8859-15/75dpi
#"

DOCS="koi8-1/doc/*"

XFS_ADD_FIRST=1
FONT_FORMAT="pcf"
FONT_SUFFIX="pcf"

FONTDIR=/usr/share/fonts/pcf/public/${PN}

src_unpack ()
{
    unpack ${A}

    for i in ${S_FONTS}
      do
      cd ${S}
      cd ${i}
      for j in *.bdf fonts.alias
	do
	sed -i -e "s/-Adobe/-rfx/g" \
	-e 's/\"Adobe/\"rfx/g' \
	\
	-e "s/koi8-1/koi8-r/g" \
	-e 's/^CHARSET_ENCODING \"1\"/CHARSET_ENCODING \"r\"/g' \
	\
	-e "s/windows/microsoft/g" \
	-e "s/-1251/-cp1251/g" \
	-e 's/^CHARSET_ENCODING \"1251\"/CHARSET_ENCODING \"cp1251\"/g' ${j}
      done
    done
}

src_compile ()
{
	for i in ${S_FONTS}
        do
    	    cd ${S}/${i}
	    for x in *.bdf 
	    do
		bdftopcf ${x} -o `basename ${x} .bdf`.pcf
		gzip `basename ${x} .bdf`.pcf
	    done
	done
}

font_src_install () 
{
	for i in ${S_FONTS}
        do
    	    cd ${S}/${i}
    	    insinto "${FONTDIR}"
	    doins *.pcf.gz
	    cat fonts.alias >> ${D}"${FONTDIR}"/fonts.alias
	done
	
	rm -f fonts.{dir,scale} encodings.dir

	font_xfont_config
	font_xft_config

	cd "${S}"
	dodoc ${DOCS}

}

# Local Variables:
# mode: sh
# End:

