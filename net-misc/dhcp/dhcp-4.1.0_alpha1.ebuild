# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus. For new version look here : http://gentoo.zugaina.org/
# This ebuild is a modified version of ebuild from http://bugs.gentoo.org/show_bug.cgi?id=205214

inherit eutils flag-o-matic multilib toolchain-funcs

MY_PV="${PV//_alpha/a}"
MY_PV="${MY_PV//_beta/b}"
MY_PV="${MY_PV//_rc/rc}"
MY_P="${PN}-${MY_PV}"
DESCRIPTION="ISC Dynamic Host Configuration Protocol"
HOMEPAGE="http://www.isc.org/products/DHCP"
SRC_URI="ftp://ftp.isc.org/isc/dhcp/${MY_P}.tar.gz"

LICENSE="isc-dhcp"
SLOT="0"
# KEYWORDS="~alpha amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd x86 ~x86-fbsd"
KEYWORDS=""
IUSE="doc minimal static selinux kernel_linux ipv6"

DEPEND="selinux? ( sec-policy/selinux-dhcp )
	kernel_linux? ( sys-apps/net-tools )"

PROVIDE="virtual/dhcpc"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
}

src_compile() {
	local myconf
	
	use static && append-ldflags -static

	cat <<-END >> includes/site.h
	#define _PATH_DHCPD_CONF "/etc/dhcp/dhcpd.conf"
	#define _PATH_DHCPD_PID "/var/run/dhcp/dhcpd.pid"
	#define _PATH_DHCPD_DB "/var/lib/dhcp/dhcpd.leases"
	#define _PATH_DHCLIENT_CONF "/etc/dhcp/dhclient.conf"
	#define _PATH_DHCLIENT_DB "/var/lib/dhcp/dhclient.leases"
	#define _PATH_DHCLIENT_PID "/var/run/dhcp/dhclient.pid"
	#define DHCPD_LOG_FACILITY LOG_LOCAL1
	END

	cat <<-END > site.conf
	CC = $(tc-getCC)
	LFLAGS = ${LDFLAGS}
	LIBDIR = /usr/$(get_libdir)
	INCDIR = /usr/include
	ETC = /etc/dhcp
	VARDB = /var/lib/dhcp
	VARRUN = /var/run/dhcp
	ADMMANDIR = /usr/share/man/man8
	ADMMANEXT = .8
	FFMANDIR = /usr/share/man/man5
	FFMANEXT = .5
	LIBMANDIR = /usr/share/man/man3
	LIBMANEXT = .3
	USRMANDIR = /usr/share/man/man1
	USRMANEXT = .1
	MANCAT = man
	END
	
	myconf="${myconf} `use_enable ipv6 dhcpv6`"
	
	./configure --includedir=/usr/include \
		${myconf} \
		|| die "configure failed"

	# Remove server support from the Makefile
	# We still install some extra crud though
	if use minimal ; then
		sed -i -e 's/\(server\|relay\|dhcpctl\)/ /g' work.*/Makefile || die
	fi
	emake || die "compile problem"
}

src_install() {
	make install DESTDIR="${D}" || die
	use doc && dodoc README RELNOTES doc/*

	insinto /etc/dhcp
	newins client/dhclient.conf dhclient.conf.sample
	keepdir /var/{lib,run}/dhcp

	# Install our server files
	if ! use minimal ; then
		insinto /etc/dhcp
		newins server/dhcpd.conf dhcpd.conf.sample
		newinitd "${FILESDIR}"/dhcpd.init dhcpd
		newinitd "${FILESDIR}"/dhcrelay.init dhcrelay
		newconfd "${FILESDIR}"/dhcpd.conf dhcpd
		newconfd "${FILESDIR}"/dhcrelay.conf dhcrelay

		# We never want portage to own this file
		rm -f "${D}"/var/lib/dhcp/dhcpd.leases
	fi
}

pkg_preinst() {
	if ! use minimal ; then
		enewgroup dhcp
		enewuser dhcp -1 -1 /var/lib/dhcp dhcp
	fi
}

pkg_postinst() {
	use minimal && return

	chown dhcp:dhcp "${ROOT}"/var/{lib,run}/dhcp

	if [[ -e "${ROOT}"/etc/init.d/dhcp ]] ; then
		ewarn
		ewarn "WARNING: The dhcp init script has been renamed to dhcpd"
		ewarn "/etc/init.d/dhcp and /etc/conf.d/dhcp need to be removed and"
		ewarn "and dhcp should be removed from the default runlevel"
		ewarn
	fi

	einfo "You can edit /etc/conf.d/dhcpd to customize dhcp settings."
	einfo
	einfo "If you would like to run dhcpd in a chroot, simply configure the"
	einfo "DHCPD_CHROOT directory in /etc/conf.d/dhcpd and then run:"
	einfo "  emerge --config =${PF}"
}

pkg_config() {
	if use minimal ; then
		eerror "${PN} has not been compiled for server support"
		eerror "emerge ${PN} without the minimal USE flag to use dhcp sever"
		return 1
	fi

	local CHROOT="$(
		sed -n -e 's/^[[:blank:]]\?DHCPD_CHROOT="*\([^#"]\+\)"*/\1/p' \
		"${ROOT}"/etc/conf.d/dhcpd
	)"

	if [[ -z ${CHROOT} ]]; then
		eerror "CHROOT not defined in /etc/conf.d/dhcpd"
		return 1
	fi

	CHROOT="${ROOT}/${CHROOT}"

	if [[ -d ${CHROOT} ]] ; then
		ewarn "${CHROOT} already exists - aborting"
		return 0
	fi

	ebegin "Setting up the chroot directory"
	mkdir -m 0755 -p "${CHROOT}/"{dev,etc,var/lib,var/run/dhcp}
	cp /etc/{localtime,resolv.conf} "${CHROOT}"/etc
	cp -R /etc/dhcp "${CHROOT}"/etc
	cp -R /var/lib/dhcp "${CHROOT}"/var/lib
	ln -s ../../var/lib/dhcp "${CHROOT}"/etc/dhcp/lib
	chown -R dhcp:dhcp "${CHROOT}"/var/{lib,run}/dhcp
	eend 0

	local logger="$(best_version virtual/logger)"
	einfo "To enable logging from the dhcpd server, configure your"
	einfo "logger (${logger}) to listen on ${CHROOT}/dev/log"
}
