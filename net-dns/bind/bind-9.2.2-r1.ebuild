# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later

IUSE="ssl ipv6 doc"

MY_P=${P/_}
S=${WORKDIR}/${MY_P}
DESCRIPTION="BIND - Name Server"
SRC_URI="ftp://ftp.isc.org/isc/bind9/${PV/_}/${MY_P}.tar.gz"
HOMEPAGE="http://www.isc.org/products/BIND/bind9-beta.html"

KEYWORDS="x86 ppc"
LICENSE="as-is"
SLOT="0"

DEPEND="sys-apps/groff
	ssl? ( >=dev-libs/openssl-0.9.6g )"

RDEPEND="${DEPEND}"

#src_unpack() 
#{
#	unpack ${A} && cd ${S}
#
#	# Adjusting PATHs in manpages
#	for i in `echo bin/{named/named.8,check/named-checkconf.8,nsupdate/nsupdate.8,rndc/rndc.8}`; do
#		sed -i -e 's:/etc/named.conf:/etc/named/named.conf:g' \
#		       -e 's:/etc/rndc.conf:/etc/named/rndc.conf:g' \
#		       -e 's:/etc/rndc.key:/etc/named/rndc.key:g' \
#		       ${i}
#	done
#}


src_compile() 
{
	local myconf

	use ssl && myconf="${myconf} --with-openssl"
	use ipv6 && myconf="${myconf} --enable-ipv6" || myconf="${myconf} --enable-ipv6=no"

	econf 	--sysconfdir=/etc/named \
		--localstatedir=/var \
		--enable-threads \
		--with-libtool \
		${myconf} || die "failed to configure bind"

	MAKEOPTS="${MAKEOPTS} -j1" emake || die "failed to compile bind"
}

src_install() 
{
	make DESTDIR=${D} install || die "failed to install bind"
	
	for x in `grep -l -d recurse -e '/etc/named.conf' -e '/etc/rndc.conf' -e '/etc/rndc.key' ${D}/usr/share/man`; do
		cp ${x} ${x}.orig
		sed -e 's:/etc/named.conf:/etc/named/named.conf:g' \
			-e 's:/etc/rndc.conf:/etc/named/rndc.conf:g' \
			-e 's:/etc/rndc.key:/etc/named/rndc.key:g' ${x}.orig > ${x}
		rm ${x}.orig
	done
	
	find ${D}/usr/share/man ! -name "*[1-8]gz" -type f -exec gzip -f "{}" \;
	insinto /usr/share/man/man5 ; doins ${FILESDIR}/named.conf.5.gz
	doman ${FILESDIR}/nslookup.8
	
	dodoc CHANGES COPYRIGHT FAQ README

	use doc && {
	docinto misc ; dodoc doc/misc/*
	docinto html ; dodoc doc/arm/*
	docinto	draft ; dodoc doc/draft/*
	docinto rfc ; dodoc doc/rfc/*
	docinto contrib ; dodoc contrib/named-bootconf/named-bootconf.sh \
	contrib/nanny/nanny.pl
	}
	
	insinto /etc/env.d
	newins ${FILESDIR}/10bind.env 10bind


	# some handy-dandy dynamic dns examples
	cd ${D}/usr/share/doc/${PF}
	tar pjxf ${FILESDIR}/dyndns-samples.tbz2

	dodir /etc/named /var/lib/named /var/lib/named/master /var/lib/named/slave

	insinto /etc/named ; doins ${FILESDIR}/named.conf
	# ftp://ftp.rs.internic.net/domain/named.ca:
	insinto /var/lib/named ; doins ${FILESDIR}/named.ca
	insinto /var/lib/named/master/fz ; doins ${FILESDIR}/localhost
	insinto /var/lib/named/master/rz ; doins ${FILESDIR}/127.0.0

	exeinto /etc/init.d ; newexe ${FILESDIR}/rc.d/named.rc6 named
	insinto /etc/conf.d ; newins ${FILESDIR}/conf.d/named.confd named
	
	dosym /var/lib/named/named.ca /var/lib/named/root.cache 
	dosym /var/lib/named/master /etc/named/master
	dosym /var/lib/named/sec	/etc/named/sec
}

pkg_preinst() {
	# Let's get rid of those tools and their manpages since they're provided by bind-tools
	rm -f ${D}/usr/share/man/man1/{dig.1.gz,host.1.gz}
	rm -f ${D}/usr/bin/{dig,host,nslookup}
}


pkg_postinst() {
	if [ ! -f '/etc/named/rndc.key' ]; then
		/usr/sbin/rndc-confgen -a -u named
	fi

	install -d -o named -g named ${ROOT}/var/run/named \
		${ROOT}/var/lib/named/master ${ROOT}/var/lib/named/slave
	chown -R named:named ${ROOT}/var/lib/named

	echo
	einfo "Bind-9.2.2_rc1 version and higher now include chroot support."
	einfo "If you would like to run bind in chroot, run:"
	einfo "\`ebuild /var/db/pkg/${CATEGORY}/${PF}/${PF}.ebuild config\`"
	echo
}

pkg_config() {
	# chroot concept contributed by j2ee (kevin@aptbasilicata.it)

	mkdir -p /chroot/{dns/{dev,etc,var/run/named}}
	chown -R named:named /chroot/dns/var/run/named
	cp -R /etc/named /chroot/dns/etc/
	cp /etc/localtime /chroot/dns/etc/localtime
	chown named:named /chroot/dns/etc/named/rndc.key
	chgrp named	/chroot/dns/etc/named/named.conf
	cp -R /var/lib/named /chroot/dns/var/
	chown -R named:named /chroot/dns/var/lib/named/{master,slave}
	mknod /chroot/dns/dev/zero c 1 5
	mknod /chroot/dns/dev/random c 1 8
	chmod 666 /chroot/dns/dev/{random,zero}

	chmod 700 /{chroot,chroot/dns}
	chown named:named /chroot/dns

	cp /etc/conf.d/named /etc/conf.d/named.orig
	sed -e 's:^#CHROOT="/chroot/dns"$:CHROOT="/chroot/dns":' \
		/etc/conf.d/named.orig > /etc/conf.d/named
	rm -f /etc/conf.d/named.orig

	echo 
	einfo "Check your config files in /chroot/dns"
	einfo "Add the following to your root .bashrc or .bash_profile: "
	einfo "   alias rndc='rndc -k /chroot/dns/etc/named/rndc.key'"
	einfo "Then do the following: "
	einfo "   source /root/.bashrc or .bash_profile"
	echo
}
