# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit etoile-svn

S1=${S}/Frameworks/AddressesKit

DESCRIPTION="Addresses for GNUstep (Kit)."
HOMEPAGE="http://www.etoile-project.org"
#SRC_URI=""
LICENSE="GPL-2"
KEYWORDS="~ppc x86 amd64"
SLOT="0"

IUSE="ldap"
DEPEND="${GS_DEPEND}"
RDEPEND="${GS_RDEPEND}"

if [ `use ldap` ]
    then
    S_ADD="Goodies/LDAPAddressBook"
    DEPEND="${DEPEND} gnustep-libs/gsldap"
    RDEPEND="${RDEPEND} gnustep-libs/gsldap"    
fi

S_ADD="${S_ADD} Goodies/adserver Goodies/adtool Goodies/adgnumailconverter"

src_unpack ()
{
    egnustep_env
    
    subversion_src_unpack
    
    # Fixes for Non-Flattened
    
    # LDFLAGS fix
    cd ${S1}
    sed -i -e "s:framework/Versions/A:framework/Versions/Current/\$(GNUSTEP_TARGET_LDIR):g" AddressManager/GNUmakefile
    
    # Headers destdir fix
    sed -i -e "s:\$(GNUSTEP_INSTALLATION_DIR)/Library/Headers/Addresses:./Addresses:g" Frameworks/Addresses/GNUmakefile
    sed -i -e "s:Library/Headers:Library/Headers/\$(LIBRARY_COMBO):g" Frameworks/Addresses/GNUmakefile
    
    # OBJCFLAGS and LDFLAGS fix
    cd ${S1}/Goodies
    
    sed -i -e "s:\(.*\)OBJCFLAGS\(.*\):\1OBJCFLAGS\2 -I../../Frameworks:" \
	-e "s:\(.*\)LDFLAGS\(.*\):\1LDFLAGS\2 -L../../Frameworks/Addresses/Addresses.framework/Versions/A/\$(GNUSTEP_TARGET_LDIR) -L../../Frameworks/AddressView/AddressView.framework/Versions/Current/\$(GNUSTEP_TARGET_LDIR):" VCFViewer/GNUmakefile

    sed -i -e "/TOOL_NAME/a\adgnumailconverter_OBJCFLAGS += -I../../Frameworks" \
	-e "s:\(.*\)LDFLAGS\(.*\):\1LDFLAGS\2 -L../../Frameworks/Addresses/Addresses.framework/Versions/Current/\$(GNUSTEP_TARGET_LDIR):" adgnumailconverter/GNUmakefile

    sed -i -e "s:../Frameworks:../../Frameworks:g" \
	-e "s:framework/Versions/A:framework/Versions/Current/\$(GNUSTEP_TARGET_LDIR):g" adserver/GNUmakefile

    sed -i -e "s:../Frameworks:../../Frameworks:g" \
	-e "s:framework/Versions/A:framework/Versions/Current/\$(GNUSTEP_TARGET_LDIR):g" adtool/GNUmakefile

    sed -i -e "s:../Frameworks:../../Frameworks:g" \
	-e "s:LDAPAddressBook_INSTALL_DIR.*:LDAPAddressBook_INSTALL_DIR=\$D\$(GNUSTEP_SYSTEM_ROOT)/Library/Addresses:g" \
	-e "s:framework/Versions/A:framework/Versions/Current/\$(GNUSTEP_TARGET_LDIR):g" LDAPAddressBook/LDAPAddressBookClass/GNUmakefile
	
}


src_compile() {
	cd ${S1}
	egnustep_env

	egnustep_make

	for i in ${S_ADD}
	  do
	  cd ${S1}/${i}
	  egnustep_make
	done
}

src_install() {
	cd ${S1}
	egnustep_env
	
	egnustep_install

	for i in ${S_ADD}
	  do
	  cd ${S1}/${i}
	  egnustep_install
	done
}
