# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

IUSE="${IUSE} doc"

MY_P="systemimager-${PV}"

S=${WORKDIR}/${MY_P}
DESCRIPTION="System imager boot-i386. Software that automates Linux installs, software distribution, and production deployment."
HOMEPAGE="http://www.systemimager.org/"
SRC_URI="mirror://sourceforge/systemimager/${MY_P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64"

DEPEND="${DEPEND}
	doc? ( app-text/dos2unix
	    app-text/docbook-sgml-utils )"
	    
RDEPEND="${DEPEND}
	~app-admin/systemimager-common-${PV}
	dev-lang/perl
	dev-perl/Config-Simple
	dev-perl/LockFile-Simple
	net-misc/flamethrower"

src_compile () 
{
	local myconf=""
	
	use doc && myconf="${myconf} SI_BUILD_DOCS=1"
        econf ${myconf} || die "Config error"    
	emake manpages
	if ( use doc ) 
	    then 
	    cd ${S}/doc/manual_source
	    make html ps
	fi
}

src_install () 
{
        einstall DESTDIR=${D} install_server

	if ( use doc ) 
	    then 
	    dohtml -r ${S}/doc/manual_source/html
	    dodoc ${S}/doc/manual_source/html/*.ps
	fi
    
	newinitd ${FILESDIR}/systemimager-server-flamethrowerd.initd systemimager-server-flamethrowerd
	newinitd ${FILESDIR}/systemimager-server-netbootmond.initd systemimager-server-netbootmond
	newinitd ${FILESDIR}/systemimager-server-rsyncd.initd systemimager-server-rsyncd
	newinitd ${FILESDIR}/systemimager-server-monitord.initd  systemimager-server-monitord
	
	keepdir /var/lock/systemimager /var/log/systemimager /var/state/systemimager/flamethrower
	    
	dodoc README* RELEASE* CHANGE.LOG COPYING CREDITS DEVELOPER_GUIDELINES ERRATA
}

