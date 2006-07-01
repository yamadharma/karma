
ECLASS="gnustep-env"
INHERITED="$INHERITED $ECLASS"

DESCRIPTION="Set GNUstep environment."

IUSE=""

newdepend	"gnustep-base/gnustep-make"

if [ -z "${GNUSTEP_ROOT}" ]
    then
    GNUSTEP_ROOT=/opt/GNUstep
fi


# LOGNAME broken in gnustep-make post 1.9.0
LOGNAME=portage

# {{{ This is hack (due broken LOGNAME)

#if [ -z "$GNUSTEP_FLATTENED" ]; then
#  addwrite `$GNUSTEP_MAKEFILES/$GNUSTEP_HOST_CPU/$GNUSTEP_HOST_OS/user_home user`/Defaults/.GNUstepDefaults.lck
#  addpredict `$GNUSTEP_MAKEFILES/$GNUSTEP_HOST_CPU/$GNUSTEP_HOST_OS/user_home user`
#else
#  addwrite `$GNUSTEP_MAKEFILES/user_home user`/Defaults/.GNUstepDefaults.lck
#  addpredict `$GNUSTEP_MAKEFILES/user_home user`
#fi

# }}}

gnustep-env_configure_env ()
{

if [ -f ${GNUSTEP_ROOT}/System/Library/Makefiles/GNUstep.sh ] 
    then
    source ${GNUSTEP_ROOT}/System/Library/Makefiles/GNUstep.sh
else
    die "gnustep-make not installed!"
fi

HOME=${T}
GNUSTEP_USER_ROOT=${T}/GNUstep

if [ -z "$GNUSTEP_FLATTENED" ]; then
  gs_defaults=`$GNUSTEP_MAKEFILES/$GNUSTEP_HOST_CPU/$GNUSTEP_HOST_OS/user_home defaults`
  gs_user=`$GNUSTEP_MAKEFILES/$GNUSTEP_HOST_CPU/$GNUSTEP_HOST_OS/user_home user`
else
  gs_defaults=`$GNUSTEP_MAKEFILES/user_home user`/Defaults/.GNUstepDefaults.lck
  gs_user=`$GNUSTEP_MAKEFILES/user_home user`
fi

echo !!!!!!!!!!!!!!!!!!!!!!! ${gs_defaults}
echo !!!!!!!!!!!!!!!!!!!!!!! ${gs_user}

addwrite ${gs_defaults}/Defaults/.GNUstepDefaults.lck
addpredict ${gs_user}

GNUSTEP_INSTALLATION_DIR=${D}${GNUSTEP_SYSTEM_ROOT}
INSTALL_ROOT_DIR=${D}
}

EXPORT_FUNCTIONS configure_env

# Local Variables:
# mode: sh
# End:
