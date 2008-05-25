# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Greylistd is a Exim4 policy server implementing greylisting"
SRC_URI="http://ftp.debian.org/debian/pool/main/g/greylistd/greylistd_0.8.6-0.1.tar.gz"
HOMEPAGE="http://packages.debian.org/unstable/source/greylistd"
LICENSE="GPL-2"
SLOT="0"
IUSE=""
DEPEND=""
RDEPEND=">=dev-lang/python-2.3.0"

KEYWORDS="x86 amd64"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /dev/null ${PN} 
}

src_install () {
	cd ${S}

	# greylistd data/DB in /var
	diropts -m0770 -o ${PN} -g ${PN}
	dodir /var/lib/${PN}
	fowners greylistd:greylistd /var/lib/greylistd
	fperms 0770 /var/lib/greylistd

	dodir /var/run/${PN}
	fowners greylistd:greylistd /var/run/greylistd
	fperms 0770 /var/run/greylistd

	# greylistd binary
	# dosbin ${PN}
	dosbin program/greylistd
	dobin	program/greylist

	# greylistd data in /etc/greylistd
	insinto /etc/greylistd
	insopts -o root -g ${PN} -m 0640
	doins config/whitelist-hosts
	doins config/config

	# documentation
	dodoc ${S}/doc/examples/*
	doman ${S}/doc/man8/greylistd.8
	doman ${S}/doc/man8/greylistd-setup-exim4.8
	doman ${S}/doc/man1/greylist.1
	
	# init.d + conf.d files
	newinitd ${FILESDIR}/greylistd-init ${PN}
}

pkg_postinst() {
	echo
	einfo "To make use of greylisting, please update your exim config:"
	einfo "Read: /usr/share/doc/greylistd-0.8.3.1/exim4-acl-example.txt.gz"
	einfo 
	einfo "In order to complete this installation you have to add the user"
	einfo "mail to the group greylistd. usermod -g mail -G greylistd mail"
	einfo
	einfo
	einfo "Also remember to make the daemon start during system boot:"
	einfo "rc-update add greylistd default"
	echo
	ewarn "Read greylistd documentation for more info."
	echo
	epause 5
}
