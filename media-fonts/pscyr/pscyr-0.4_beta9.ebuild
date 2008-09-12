# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

IUSE=""

MY_PN=PSCyr
MY_P=${MY_PN}-${PV/_/-}
S=${WORKDIR}/PSCyr

DESCRIPTION="PSCyr font collection"
HOMEPAGE="ftp://scon155.phys.msu.su/pub/russian/psfonts"
SRC_URI="ftp://scon155.phys.msu.su/pub/russian/psfonts/0.4d-beta/${MY_P}-tex.tar.gz
ftp://scon155.phys.msu.su/pub/russian/psfonts/0.4d-beta/${MY_P}-type1.tar.gz"

DEPEND="app-text/tex-base"

LICENSE="LPPL-1.2"
SLOT="0"
KEYWORDS="x86 amd64"

has_tetex_3 () 
{
	if has_version '>=app-text/tetex-3' || has_version '>=app-text/ptex-3.1.8' ; then
		true
	else
		false
	fi
}


tex-set-env ()
{
    if has_tetex_3
	then
	TEXMF=`kpsewhich -expand-var='$TEXMFDIST'`
	VARTEXMF=`kpsewhich -expand-var='$TEXMFSYSVAR'`
        VARTEXFONTS=`kpsewhich -expand-var='$VARTEXFONTS'`
    else
	TEXMF=`kpsewhich -expand-var='$TEXMFMAIN'`
	VARTEXMF=`kpsewhich -expand-var='$VARTEXMF'`
        VARTEXFONTS=`kpsewhich -expand-var='$VARTEXFONTS'`
    fi
}

src_install () 
{
    tex-set-env
    
    dodir ${TEXMF}
    cd ${S}
    
    cp -r tex ${D}/${TEXMF}
    cp -r fonts ${D}/${TEXMF}

    if has_tetex_3
    	then

	dodir ${TEXMF}/fonts/enc/dvips/pscyr
	dodir ${TEXMF}/fonts/map/dvips/pscyr
	cp dvips/pscyr/*.enc ${D}/${TEXMF}/fonts/enc/dvips/pscyr
	cp dvips/pscyr/*.map ${D}/${TEXMF}/fonts/map/dvips/pscyr

	insinto /etc/texmf/updmap.d
	doins ${FILESDIR}/90pscyr.cfg

    else
	cp -r dvipdfm dvips ${D}/${TEXMF}
    fi
    
    dodoc LICENSE ChangeLog
    
    dodoc doc/*
    docinto old
    cd ${S}/doc/old
    dodoc *

}

pkg_postinst () 
{
    tex-set-env

    if has_tetex_3 
	then
	texmf-update
    else
	texconfig rehash
    fi    

    
    if ( ! has_tetex_3 )
	then
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
    fi
}

pkg_postrm () 
{
    tex-set-env
    
    einfo "Removing pk fonts..."
    
    rm -f $VARTEXFONTS/pk/modeless/public/pscyr/*
    rm -f $TEXMF/fonts/pk/modeless/public/pscyr/*
    rm -f $VARTEXMF/fonts/pk/modeless/public/pscyr/*

    if ( ! has_tetex_3 )
	then    
	if [ -z "$VARTEXMF" ]
	    then 
	    cd $TEXMF/web2c
	else
	    cd $VARTEXMF/web2c
	fi

	sed "/^# PSCyr/d" updmap.cfg
	sed "/pscyr.map/d" updmap.cfg
	/usr/bin/updmap
    fi

    if has_tetex_3 
	then
	texmf-update
    else
	texconfig rehash
    fi    

}

# Local Variables:
# mode: sh
# End:

