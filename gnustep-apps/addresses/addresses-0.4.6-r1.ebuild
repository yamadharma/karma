# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/addresses/addresses-0.4.6.ebuild,v 1.1 2004/09/24 01:06:14 fafhrd Exp $

inherit gnustep

S=${WORKDIR}/${P/a/A}

DESCRIPTION="Addresses is a Apple Addressbook work alike (standalone and for GNUMail)"
HOMEPAGE="http://giesler.biz/bjoern/en/sw_addr.html"
#SRC_URI="mirror://gentoo/${P/a/A}.tar.gz"
#SRC_URI="http://dev.gentoo.org/~fafhrd/gnustep/apps/${P/a/A}.tar.gz"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/contrib/${P/a/A}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86"

IUSE="${IUSE} ldap"
DEPEND="${GS_DEPEND}"
RDEPEND="${GS_RDEPEND}"

if [ `use ldap` ]
    then
    S_ADD="Goodies/LDAPAddressBook"
    newdepend	"gnustep-libs/gsldap"
fi

S_ADD="${S_ADD} Goodies/adserver Goodies/adtool"


src_unpack ()
{
    egnustep_env
    
    unpack ${A}

    # Fixes for Non-Flattened
    
    # LDFLAGS fix
    cd ${S}
    sed -i -e "s:framework/Versions/A:framework/Versions/A/\$(GNUSTEP_TARGET_LDIR):g" AddressManager/GNUmakefile
    
    # Headers destdir fix
    sed -i -e "s:\$(GNUSTEP_INSTALLATION_DIR)/Library/Headers/Addresses:./Addresses:g" Frameworks/Addresses/GNUmakefile
    sed -i -e "s:Library/Headers:Library/Headers/\$(LIBRARY_COMBO):g" Frameworks/Addresses/GNUmakefile
    
    # OBJCFLAGS and LDFLAGS fix
    cd ${S}/Goodies
    
    sed -i -e "s:\(.*\)OBJCFLAGS\(.*\):\1OBJCFLAGS\2 -I../../Frameworks:" \
	-e "s:\(.*\)LDFLAGS\(.*\):\1LDFLAGS\2 -L../../Frameworks/Addresses/Addresses.framework/Versions/A/\$(GNUSTEP_TARGET_LDIR) -L../../Frameworks/AddressView/AddressView.framework/Versions/A/\$(GNUSTEP_TARGET_LDIR):" VCFViewer/GNUmakefile

    sed -i -e "/TOOL_NAME/a\adgnumailconverter_OBJCFLAGS += -I../../Frameworks" \
	-e "s:\(.*\)LDFLAGS\(.*\):\1LDFLAGS\2 -L../../Frameworks/Addresses/Addresses.framework/Versions/A/\$(GNUSTEP_TARGET_LDIR):" adgnumailconverter/GNUmakefile

    sed -i -e "s:../Frameworks:../../Frameworks:g" \
	-e "s:framework/Versions/A:framework/Versions/A/\$(GNUSTEP_TARGET_LDIR):g" adserver/GNUmakefile

    sed -i -e "s:../Frameworks:../../Frameworks:g" \
	-e "s:framework/Versions/A:framework/Versions/A/\$(GNUSTEP_TARGET_LDIR):g" adtool/GNUmakefile

    sed -i -e "s:../Frameworks:../../Frameworks:g" \
	-e "s:LDAPAddressBook_INSTALL_DIR.*:LDAPAddressBook_INSTALL_DIR=\$D\$(GNUSTEP_SYSTEM_ROOT)/Library/Addresses:g" \
	-e "s:framework/Versions/A:framework/Versions/A/\$(GNUSTEP_TARGET_LDIR):g" LDAPAddressBook/LDAPAddressBookClass/GNUmakefile
	
}

src_compile() {
	egnustep_env

	egnustep_make

	for i in ${S_ADD}
	  do
	  cd ${S}/${i}
	  egnustep_make
	done
}

src_install ()
{
	egnustep_env
	
	egnustep_install

	for i in ${S_ADD}
	  do
	  cd ${S}/${i}
	  egnustep_install
	done
}
