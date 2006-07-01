
ECLASS="gnustep-app"

inherit gnustep-env patch extrafiles doc-tex
INHERITED="$INHERITED $ECLASS"

DESCRIPTION="Based on the gnustep eclass."

IUSE="doc"

newdepend	"gnustep-base/gnustep-make"
newdepend	"gnustep-base/gnustep-base"

EXPORT_FUNCTIONS src_unpack src_compile src_install

gnustep-app_src_unpack ()
{
    configure_env
    
    patch_src_unpack

    cd ${S}
}


gnustep-app_src_compile () 
{
    configure_env
    
    if [ -x configure ]  
 	then
	./configure \
	    ${myconf} \
	    || die "configure failed"
    fi    


    make \
	HOME=${T} \
	GNUSTEP_USER_ROOT=${T}/GNUstep \
	GNUSTEP_INSTALLATION_DIR=${GNUSTEP_SYSTEM_ROOT} \
	|| die



    if [ ! -z "${S_ADD}" ]
	then
	for i in ${S_ADD}
	  do
	  cd ${S}
	  cd ${i}
	  make \
	      HOME=${T} \
	      GNUSTEP_USER_ROOT=${T}/GNUstep \
	      || die
	done
    fi
    

    if ( use doc )
	then
	if [ ! -z "${extradocdir}" ]
	    then
	    for i in "${extradocdir}"
	    do
		cd ${S}
		cd ${i}
		make \
		    HOME=${T} \
		    GNUSTEP_USER_ROOT=${T}/GNUstep \
		    || die
	    done
	fi
    fi
}

gnustep-app_src_install () 
{
    configure_env
    
    cd ${S}

    make \
	GNUSTEP_USER_ROOT=${T}/GNUstep \
	HOME=${T} \
	GNUSTEP_INSTALLATION_DIR=${D}${GNUSTEP_SYSTEM_ROOT} \
	INSTALL_ROOT_DIR=${D} \
	install || die
    
    if [ ! -z "${S_ADD}" ]
	then
	for i in ${S_ADD}
	  do
	  cd ${S}
	  cd ${i}
	  make \
	      GNUSTEP_USER_ROOT=${T}/GNUstep \
	      HOME=${T} \
	      GNUSTEP_INSTALLATION_DIR=${D}${GNUSTEP_ROOT}/System \
	      GNUSTEP_LOCAL_ROOT=${D}${GNUSTEP_ROOT}/Local \
	      GNUSTEP_NETWORK_ROOT=${D}${GNUSTEP_ROOT}/Network \
	      GNUSTEP_SYSTEM_ROOT=${D}${GNUSTEP_ROOT}/System \
	      INSTALL_ROOT_DIR=${D} \
	      install || die
	done
    fi
    
    if [ ! -z "${mydoc}" ]
	then
	cd ${S}
	dodoc ${mydoc}
    fi

    if ( use doc )
	then
	if [ ! -z "${extradocdir}" ]
	    then
	    for i in "${extradocdir}"
	    do
		cd ${S}
		cd ${i}
		make \
	    	    GNUSTEP_USER_ROOT=${T}/GNUstep \
	    	    HOME=${T} \
	    	    GNUSTEP_INSTALLATION_DIR=${D}${GNUSTEP_ROOT}/System \
	    	    GNUSTEP_LOCAL_ROOT=${D}${GNUSTEP_ROOT}/Local \
	    	    GNUSTEP_NETWORK_ROOT=${D}${GNUSTEP_ROOT}/Network \
	    	    GNUSTEP_SYSTEM_ROOT=${D}${GNUSTEP_ROOT}/System \
	    	    INSTALL_ROOT_DIR=${D} \
	    	    install || die
	    done
	fi
    fi

    extrafiles_install
}

# Local Variables:
# mode: sh
# End:
