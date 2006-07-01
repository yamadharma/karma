
ECLASS="gnustep-app-gui"

inherit gnustep-app
INHERITED="$INHERITED $ECLASS"

DESCRIPTION="GNUstep GUI Applications eclass."

newdepend	"gnustep-base/gnustep-gui"


gnustep-app-gui_src_unpack ()
{
    gnustep-app_src_unpack
}

gnustep-app-gui_src_compile ()
{
    gnustep-app_src_compile
}

gnustep-app-gui_src_install ()
{
    gnustep-app_src_install
}

# EXPORT_FUNCTIONS src_unpack src_compile src_install

# Local Variables:
# mode: sh
# End:
