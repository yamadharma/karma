# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE=""

MY_P=${P}-glibc.2.2
S=${WORKDIR}/${MY_P}
DESCRIPTION="Drweb virus scanner"
HOMEPAGE="http://www.drweb.ru/"
SRC_URI="ftp://ftp.dials.ru/dsav/english/drweb32/${MY_P}.tar.gz"

# unzip and wget are needed for the check-updates.sh script
RDEPEND="dev-perl/String-CRC32
	>=net-misc/wget-1.8.2"

#>=app-arch/unzip-5.42-r1


SLOT="0"
LICENSE="DrWEB"
KEYWORDS="x86 sparc sparc64"

#src_unpack () {
#
#	unpack ${A}
#	cd ${S}
#	pwd
#	patch -p0 < ${FILESDIR}/patch/${PV}/path.diff
#
#}

src_compile () {
    echo "Nothing to compile."
}

src_install () 
{
  cd ${S}/install
  cp -R * ${D}
  rm -fr ${D}/etc/init.d
  
  mkdir ${D}/var/lib
  mv ${D}/var/drweb ${D}/var/lib
  
  cd ${D}/etc/drweb/
  sed -e "s:/var/drweb:/var/lib/drweb:g" drweb32.ini > drweb32.ini.tmp
  mv -f drweb32.ini.tmp drweb32.ini
  
  
#    doman man8/*.8
#    dodoc LICENSE CHANGES INSTALL* README
#
#    dodir /opt/f-prot /opt/f-prot/tmp
#    insinto /opt/f-prot
#    insopts -m 755
#    doins f-prot f-prot.sh check-updates.sh checksum
#    insopts -m 644
#    doins *.DEF ENGLISH.TX0
}
