# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="DrWeb virus scaner for Linux"
HOMEPAGE="http://www.drweb.com"
SRC_URI="ftp://ftp.drweb.com/pub/drweb/unix/Linux/Generic/drweb-${PV}-unix-glibc27.tar.bz2
	X? ( ftp://ftp.drweb.com/pub/drweb/unix/Linux/Generic/drweb-x-${PV}-glibc2.7.tar.bz2 )"

#SRC_URI="ftp://ftp.drweb.com/pub/drweb/unix/Linux/Generic/glibc2.6/drweb-${PV}-glibc2.6.tar.bz2
#	X? ( ftp://ftp.drweb.com/pub/drweb/unix/Linux/Generic/glibc2.6/drweb-x-${PV}-glibc2.6.tar.bz2 )"

RESTRICT="mirror strip"

SLOT="0"
LICENSE="DRWEB"
KEYWORDS="x86 amd64"
IUSE="X daemon logrotate"

DEPEND="app-arch/unzip"
RDEPEND="${DEPEND}
	dev-perl/libwww-perl
	virtual/cron
	sys-devel/gcc
	>=sys-libs/glibc-2.7
	logrotate? ( app-admin/logrotate )"

PROVIDE="virtual/antivirus"

src_unpack() {
	unpack ${A}
}

pkg_setup() {
	# Create drweb user/group
	enewgroup drweb
	enewuser drweb -1 -1 /var/drweb drweb
}

src_compile() {
	einfo "Nothing to compile, installing DrWeb..."
}

src_install() {
	components="drweb"
	if use X ; then
		components="${components} drweb-x"
	fi

	for comp in ${components} ; do
		insinto /
		doins -r ${WORKDIR}/${comp}-${PV}-glibc2.7/*
	done
	
	if use X ; then
		fperms +x /opt/drweb/drweb-gui
		dosym /opt/drweb/drweb-gui /usr/bin/xdrweb
	fi

	fperms +x /opt/drweb/drweb
	# Create log dir in proper location
	dodir /var/log/drweb
	dodir /var/spool/drweb
	dodir /var/run/drweb
	dodir /var/drweb/{bases,infected,ipc,updates}

	# Set up permissions
	fowners drweb:drweb /opt/drweb/lib
	fowners drweb:drweb /var/drweb/{bases,infected,ipc,updates}
	fowners drweb:drweb /etc/drweb/email.ini
	fowners drweb:drweb /var/log/drweb
	fowners drweb:drweb /var/spool/drweb
	fowners drweb:drweb /var/run/drweb
	fperms 0640 /etc/drweb/email.ini
	fperms 0750 /var/drweb/infected
	fperms 0700 /var/run/drweb
	fperms 0700 /var/drweb/updates
	fperms 0770 /var/spool/drweb
	fperms +x /opt/drweb/update.pl
	chown -R drweb:drweb ${D}/var/drweb/bases
	chown -R drweb:drweb ${D}/opt/drweb/lib
		
	rm -f ${D}/etc/drweb/drweb-log
	rm -f ${D}/etc/init.d/drwebd

	local docdir="${D}/opt/drweb/doc"
	for doc in ${docdir}/{ChangeLog,FAQ,readme.eicar,readme.license} \
		    ${docdir}/daemon/readme.daemon \
		    ${docdir}/scanner/readme.scanner \
		    ${docdir}/update/readme.update ; do
		dodoc ${doc} && rm -f ${doc}
	done

	dodoc ${D}/opt/drweb/getkey.HOWTO

	rm -rf ${docdir} && rm -f ${D}/opt/drweb/getkey.*

	if ! use logrotate ; then
		rm -rf ${D}/etc/logrotate.d
	fi

	if use daemon ; then
		newinitd ${FILESDIR}/drweb.initd drwebd
		fperms +x /opt/drweb/drwebd
	else
		rm -f ${D}/opt/drweb/drwebd
	fi
	
	#Fixing locations in config
	sed -i -e s/"\/var\/drweb\/log"/"\/var\/log\/drweb"/g "${D}/etc/drweb/drweb32.ini" || die
	sed -i -e s/"\/var\/drweb\/run"/"\/var\/drweb\/run"/g "${D}/etc/drweb/drweb32.ini" || die
	sed -i -e s/"\/var\/drweb\/spool"/"\/var\/drweb\/spool"/g "${D}/etc/drweb/drweb32.ini" || die
}
