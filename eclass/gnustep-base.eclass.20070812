
ECLASS=gnustep-base
INHERITED="$INHERITED $ECLASS"

inherit patch extrafiles doc-tex gnustep-env

DESCRIPTION="Based on the gnustep eclass."

IUSE="doc"

DEPEND="${DEPEND}"


gnustep-base_pkg_setup ()
{
    doc-tex_pkg_setup
    mkdir -p ${T}/GNUstep
}

gnustep-base_src_unpack ()
{
    patch_src_unpack

    cd ${S}
}


gnustep-base_src_compile () 
{
    configure_env

    cd ${S}

    ./configure \
	HOME=${T} \
	GNUSTEP_USER_ROOT=${T}/GNUstep \
	INSTALL_AS_USER=portage \
	${myconf} \
	|| die "configure failed"
    
    make \
	HOME=${T} \
	GNUSTEP_USER_ROOT=${T}/GNUstep \
	|| die
	
    if ( use doc )
	then
	cd ${S}/Documentation
	make \
	    HOME=${T} \
	    GNUSTEP_USER_ROOT=${T}/GNUstep \
	    || die
    fi
}

gnustep-base_src_install () 
{
    configure_env    

    cd ${S}
    
    make \
	GNUSTEP_USER_ROOT=${T}/GNUstep \
	HOME=${T} \
	GNUSTEP_INSTALLATION_DIR=${D}${GNUSTEP_SYSTEM_ROOT} \
	INSTALL_ROOT_DIR=${D} \
	install || die
    
    if ( use doc )
	then
	cd ${S}/Documentation
	make \
	    GNUSTEP_INSTALLATION_DIR=${D}${GNUSTEP_SYSTEM_ROOT} \
	    INSTALL_ROOT_DIR=${D} \
	    install || die
    fi
}

EXPORT_FUNCTIONS pkg_setup src_unpack src_compile src_install

# Local Variables:
# mode: sh
# End:
