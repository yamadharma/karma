# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2

IUSE=""

S=${WORKDIR}/PSCyr
MY_P=${P//d}-beta7
DESCRIPTION="PSCyr font collection"
HOMEPAGE="ftp://scon155.phys.msu.su/pub/russian/psfonts"
SRC_URI="ftp://scon155.phys.msu.su/pub/russian/psfonts/0.4d-beta/${MY_P}-tex.tar.gz
ftp://scon155.phys.msu.su/pub/russian/psfonts/0.4d-beta/${MY_P}-type1.tar.gz"

DEPEND="app-text/tetex"

LICENSE="LPPL-1.2"
SLOT="0"
KEYWORDS="x86 sparc sparc64 ppc"

TEXMF=`kpsewhich -expand-var='$TEXMFMAIN'`
VARTEXMF=`kpsewhich -expand-var='$VARTEXMF'`

src_install () 
{
    dodir ${TEXMF}
    cd ${S}
    cp -r dvipdfm dvips tex ${D}/${TEXMF}
    
    cp -r fonts ${D}/${TEXMF}
#  dodir /usr/share
#  cp -r fonts ${D}/usr/share
    
    dodoc LICENSE ChangeLog
    
    dodoc doc/*
    docinto old
    cd ${S}/doc/old
    dodoc *
}

pkg_postinst () 
{
    mktexlsr
    
    if [ -z "$VARTEXMF" ]
	then 
	cd $TEXMF/web2c
    else
	cd $VARTEXMF/web2c
	if [ ! -f updmap.cfg ]
	    then
	    cp $TEXMF/web2c/updmap.cfg $VARTEXMF/web2c
	fi
    fi

    echo -e "\n# PSCyr\nMap pscyr.map\n" >> updmap.cfg

    /usr/bin/updmap
}

pkg_postrm () 
{
    einfo "Removing pk fonts..."
    
    VARTEXFONTS=`kpsewhich -expand-var='$VARTEXFONTS'`
    rm -f $VARTEXFONTS/pk/modeless/public/pscyr/*
    
    rm -f $TEXMF/fonts/pk/modeless/public/pscyr/*

    mktexlsr

    if [ -z "$VARTEXMF" ]
	then 
	cd $TEXMF/web2c
    else
	cd $VARTEXMF/web2c
    fi

    
    sed "/^# PSCyr/d" updmap.cfg
    sed "/pscyr.map/d" updmap.cfg
    
    /usr/bin/updmap
}

# Local Variables:
# mode: sh
# End:

