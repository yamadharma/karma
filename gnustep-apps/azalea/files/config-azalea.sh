#!/bin/sh

bundledir="$GNUSTEP_SYSTEM_ROOT/Library/Bundles"

echo
echo "Going to set or reset some preferences/defaults"
echo
echo "Resetting GSAppKitUserBundles and NSUseRunningCopy (in NSGlobalDomain)"

#defaults write NSGlobalDomain GSAppKitUserBundles "($bundledir/Camaelon.themeEngine, $bundledir/EtoileMenus.bundle, $bundledir/EtoileBehavior.bundle)"
# NSUseRunningCopy equals to YES avoids to launch another copy of an 
# already running application (AppKit-based process).
defaults write NSGlobalDomain NSUseRunningCopy YES
	
echo "Setting User Interface Theme to Nesedah (in Camaelon domain)"
defaults write Camaelon Theme "Nesedah"

# As a safety mesure in case the user want to use GWorkspace in Etoile
# context, we set some GWorkspace defaults
defaults write GWorkspace NoWarnOnQuit YES
defaults write NSGlobalDomain GSWorkspaceApplication "NotExist.app"

