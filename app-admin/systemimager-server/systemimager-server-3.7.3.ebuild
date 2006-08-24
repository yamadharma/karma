# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

IUSE="${IUSE} bittorrent doc"

MY_P="systemimager-${PV}"

BITTORRENT_VERSION=4.4.0

S=${WORKDIR}/${MY_P}
DESCRIPTION="System imager boot-i386. Software that automates Linux installs, software distribution, and production deployment."
HOMEPAGE="http://www.systemimager.org/"
SRC_URI="mirror://sourceforge/systemimager/${MY_P}.tar.bz2
	bittorrent? http://download.systemimager.org/pub/bittorrent/BitTorrent-${BITTORRENT_VERSION}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"

DEPEND="${DEPEND}
	doc? ( app-text/dos2unix
	    app-text/docbook-sgml-utils )"
	    
RDEPEND="${DEPEND}
	~app-admin/systemimager-common-${PV}
	dev-lang/perl
	dev-perl/Config-Simple
	dev-perl/LockFile-Simple
	net-misc/flamethrower
	bittorrent? ( >=net-p2p/bittorrent-${BITTORRENT_VERSION} )" 

src_unpack ()
{
        unpack ${MY_P}.tar.bz2
	mkdir -p ${S}/initrd_source/src
	
	use bittorrent && cp ${DISTDIR}/BitTorrent-${BITTORRENT_VERSION}.tar.gz ${S}/initrd_source/src
}

src_compile () 
{
	local myconf=""
	
	use doc && myconf="${myconf} SI_BUILD_DOCS=1"
        econf ${myconf} || die "Config error"    
        
	emake manpages

        emake bittorrent

	if ( use doc ) 
	    then 
	    cd ${S}/doc/manual_source
	    make html ps
	fi
}

src_install () 
{
	if ( use bittorrent )
	    then
	    einstall DESTDIR=${D} \
		install_server_man \
		install_configs	\
		install_server_libs
	else
    	    einstall DESTDIR=${D} install_server
        fi

	if ( use doc ) 
	    then 
	    dohtml -r ${S}/doc/manual_source/html
	    dodoc ${S}/doc/manual_source/html/*.ps
	fi
	
	rm -f ${D}/etc/init.d/*
	newinitd ${FILESDIR}/systemimager-server-flamethrowerd.initd systemimager-server-flamethrowerd
	newinitd ${FILESDIR}/systemimager-server-netbootmond.initd systemimager-server-netbootmond
	newinitd ${FILESDIR}/systemimager-server-rsyncd.initd systemimager-server-rsyncd
	newinitd ${FILESDIR}/systemimager-server-monitord.initd  systemimager-server-monitord
	use bittorrent && newinitd ${FILESDIR}/systemimager-server-bittorrent.initd  systemimager-server-bittorrent
	
	keepdir /var/lock/systemimager /var/log/systemimager /var/state/systemimager/flamethrower
	use bittorrent && keepdir /var/lib/systemimager/torrents /var/lib/systemimager/tarballs
	    
	dodoc README* RELEASE* CHANGE.LOG COPYING CREDITS DEVELOPER_GUIDELINES ERRATA
	
	if ( ! use bittorrent )
	    then
	    cd ${D}/usr/bin
	    rm bittorrent* launchmany* changetracker* torrentinfo* maketorrent*
	    rm ${D}/usr/sbin/si_installbtimage
	    rm -rf ${D}/usr/share/doc/BitTorrent* ${D}/usr/share/locale ${D}/usr/share/pixmaps ${D}/usr/lib/python*
	    rm ${D}/etc/systemimager/bittorrent.conf
	fi
}

