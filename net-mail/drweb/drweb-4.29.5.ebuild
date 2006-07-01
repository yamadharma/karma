# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE=""

S=${WORKDIR}/${MY_P}

DESCRIPTION="Drweb virus scanner"
HOMEPAGE="http://www.drweb.ru/"
SRC_URI="ftp://ftp.drweb.ru/pub/unix/${PV}/${P}-glibc.2.2.tar.gz
ftp://ftp.drweb.ru/pub/unix/${PV}/${P}-glibc.2.3.tar.gz"

# SRC_URI="ftp://ftp.dials.ru/dsav/english/drweb32/${PV}/${MY_P}.tar.gz"

# unzip and wget are needed for the check-updates.sh script
RDEPEND="dev-perl/String-CRC32
	>=net-misc/wget-1.8.2"

SLOT="0"
LICENSE="DrWEB"
KEYWORDS="x86"

pkg_setup() 
{
	if ! groupmod vscan; 
	then
		groupadd -g 426 vscan || die "problem adding group vscan"
	fi

	if ! id vscan; 
	then
		useradd -u 426 -g vscan -s /bin/false -d /var/tmp -c "vscan" vscan
		assert "problem adding user vscan"
	fi
	
}

src_unpack () 
{
    GLIBC=`best_version sys-libs/glibc`

    case ${GLIBC} in
    sys-libs/glibc-2.3.*)
	VER_GLIBC=2.3
	MY_P=${P}-glibc.2.3
    ;;
    sys-libs/glibc-2.2.*|*)
	VER_GLIBC=2.2
	MY_P=${P}-glibc.2.2
    ;;
    esac

    unpack ${P}-glibc.${VER_GLIBC}.tar.gz
}

src_compile () 
{
    echo "Nothing to compile."
}

src_install () 
{
    cd ${S}/install
    cp -R * ${D}
    rm -fr ${D}/etc/init.d
  
    dodir /var/lib
    mv ${D}/var/drweb ${D}/var/lib
  
    # Docs
    cd ${S}/install/opt/drweb/doc
    dodoc *
    rm -rf ${D}/opt/drweb/doc
    
    # Links
    dodir /usr/bin
    dosym /opt/drweb/drweb /usr/bin/drweb
    
    # Ini-file tuning
    dosed  "s:/var/drweb:/var/lib/drweb:g" /etc/drweb/drweb32.ini 
    dosed  "s:;User = drweb:User = vscan:g" /etc/drweb/drweb32.ini     
#    dosed "s&;LngFileName=&LngFileName=/opt/drweb/lib/english.dwl&" /etc/drweb/drweb32.ini

    # Set permissions    
    chown -R vscan:vscan  ${D}/var/lib/drweb
}
