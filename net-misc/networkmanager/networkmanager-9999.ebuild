# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils subversion

# NetworkManager likes itself with capital letters
MY_P=${P/networkmanager/NetworkManager}

DESCRIPTION="Network configuration and management in an easy way. Desktop environment independent."
HOMEPAGE="http://www.gnome.org/projects/NetworkManager/"
ESVN_REPO_URI="svn://svn.gnome.org/svn/NetworkManager/trunk"

SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc gnome nss gnutls dhclient dhcpcd"

S=${WORKDIR}/${MY_P}

RDEPEND=">=sys-apps/dbus-1.2
        >=dev-libs/dbus-glib-0.75
        >=sys-apps/hal-0.5.10
        >=net-wireless/wireless-tools-28_pre9
        >=dev-libs/glib-2.16
        >=sys-auth/policykit-0.8
        >=dev-libs/libnl-1.1
        >=net-wireless/wpa_supplicant-0.5.10
        || ( sys-libs/e2fsprogs-libs <sys-fs/e2fsprogs-1.41.0 )

        gnutls? (
                nss? ( >=dev-libs/nss-3.11 )
                !nss? ( dev-libs/libgcrypt  
                                net-libs/gnutls ) )
        !gnutls? ( >=dev-libs/nss-3.11 )

        dhclient? (
                dhcpcd? ( >=net-misc/dhcpcd-4.0.0_rc3 )
                !dhcpcd? ( >=net-misc/dhcp-3.0.0 ) )   
        !dhclient? ( >=net-misc/dhcpcd-4.0.0_rc3 )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool
	net-dialup/ppp
	>=dev-util/gtk-doc-1.8
	>=dev-util/intltool-0.35"

PDEPEND="gnome? ( >=gnome-extra/nm-applet-0.7.0_pre0 )
	kde? ( >=kde-misc/knetworkmanager-0.7_pre0 )"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	if ! built_with_use net-wireless/wpa_supplicant dbus ; then
		eerror "Please rebuild net-wireless/wpa_supplicant with the dbus useflag."
		die "Fix wpa_supplicant first."
	fi

}

src_unpack () {
	subversion_src_unpack ${A}
	cd "${S}"

	# Fix up the dbus conf file to use plugdev group
	epatch "${FILESDIR}/${PN}-0.7.0-confchanges.patch"
	gtkdocize
	intltoolize
	eautoreconf 
}

src_compile() {
	ECONF="--disable-more-warnings \
		--localstatedir=/var \
		--with-distro=gentoo \
		--with-dbus-sys=/etc/dbus-1/system.d
		$(use_enable doc gtk-doc)
		$(use_with doc docs)"

	# default is dhcpcd (if none or both are specified), ISC dchclient otherwise
	if use dhclient ; then
		if use dhcpcd ; then
			ECONF="${ECONF} --with-dhcp-client=dhcpcd"
		else
			ECONF="${ECONF} --with-dhcp-client=dhclient"
		fi
	else
		ECONF="${ECONF} --with-dhcp-client=dhcpcd"
	fi

	# default is NSS (if none or both are specified), GnuTLS otherwise
	if use gnutls ; then
		if use nss ; then
			ECONF="${ECONF} --with-crypto=nss"
		else
			ECONF="${ECONF} --with-crypto=gnults"
		fi
	else
		ECONF="${ECONF} --with-crypto=nss"
	fi

	econf ${ECONF} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	# Need to keep the /var/run/NetworkManager directory
	keepdir /var/run/NetworkManager

	dodoc AUTHORS ChangeLog NEWS README TODO

	# Add keyfile plugin support
	insinto /etc/NetworkManager
	newins "${FILESDIR}/nm-system-settings.conf" nm-system-settings.conf
}

pkg_postinst() {
	elog "You need to be in the plugdev group in order to use NetworkManager"
	elog "Problems with your hostname getting changed?"
	elog ""
	elog "Add the following to /etc/dhcp/dhclient.conf"
	elog 'send host-name "YOURHOSTNAME";'
	elog 'supersede host-name "YOURHOSTNAME";'
	elog ""
	elog "You will need to restart DBUS if this is your first time"
	elog "installing NetworkManager."
	elog ""
	elog "To save system-wide settings as a user, that user needs to have the"
	elog "right policykit privileges. You can add them by running:"
	elog 'polkit-auth --grant org.freedesktop.network-manager-settings.system.modify "USERNAME"'
}
