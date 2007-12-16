# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic eutils multilib subversion autotools

NETJACK="netjack-0.12"
JACKDBUS="jackpatches-0.2"

RESTRICT="nostrip nomirror"
DESCRIPTION="A low-latency audio server"
HOMEPAGE="http://www.jackaudio.org"
SRC_URI="netjack? ( mirror://sourceforge/netjack/${NETJACK}.tar.bz2 )
dbus? ( http://dl.sharesource.org/jack/${JACKDBUS}.tar.bz2 )"

ESVN_REPO_URI="http://subversion.jackaudio.org/jack/trunk/jack"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="3dnow altivec alsa caps coreaudio dbus doc debug jack-tmpfs mmx oss sndfile netjack
sse jackmidi freebob"

RDEPEND="dev-util/pkgconfig
	netjack? ( !media-sound/netjack )
	sndfile? ( >=media-libs/libsndfile-1.0.0 )
	sys-libs/ncurses
	caps? ( sys-libs/libcap )
	alsa? ( >=media-libs/alsa-lib-0.9.1 )
	netjack? ( dev-util/scons )
	jackmidi? ( media-libs/alsa-lib )
	freebob? ( sys-libs/libfreebob )
	dbus? ( sys-apps/dbus 
			dev-python/dbus-python )
	!media-sound/jack-audio-connection-kit-svn"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

pkg_setup() {
	if ! use sndfile ; then
		ewarn "sndfile not in USE flags. jack_rec will not be installed!"
	fi

	if use caps; then
		if [[ "${KV:0:3}" == "2.4" ]]; then
			einfo "will build jackstart for 2.4 kernel"
		else
			einfo "using compatibility symlink for jackstart"
		fi
	fi

}

src_unpack() {
	subversion_src_unpack
	use netjack && cd ${WORKDIR} && unpack ${NETJACK}.tar.bz2
	use dbus && cd ${WORKDIR} && unpack ${JACKDBUS}.tar.bz2
	cd ${S}

	epatch ${FILESDIR}/${PN}-transport.patch

	# jack transport patch from Torben Hohn
	epatch "${FILESDIR}/jack-transport-start-at-zero-fix.diff"

	# dbus patches from Nedko Arnaudov
	if use dbus; then
		for i in `cat ../${JACKDBUS}/order`; do
			epatch "../${JACKDBUS}/$i"
		done
	fi
}

src_compile() {
	sed -i -e "s:include/nptl/:include/:g" configure.ac || die
	eautoreconf
	
	local myconf

	sed -i "s/^CFLAGS=\$JACK_CFLAGS/CFLAGS=\"\$JACK_CFLAGS $(get-flag -march)\"/" configure || die

	use doc && myconf="--with-html-dir=/usr/share/doc/${PF}"

	if use jack-tmpfs; then
		myconf="${myconf} --with-default-tmpdir=/dev/shm"
	else
		myconf="${myconf} --with-default-tmpdir=/var/run/jack"
	fi

	if use dbus; then
		myconf="${myconf} --enable-dbus --enable-pkg-config-dbus-service-dir"
	fi

	if use userland_Darwin ; then
		append-flags -fno-common
		use altivec && append-flags -force_cpusubtype_ALL \
			-maltivec -mabi=altivec -mhard-float -mpowerpc-gfxopt
	fi

	use sndfile && \
		export SNDFILE_CFLAGS="-I/usr/include" \
		export SNDFILE_LIBS="-L/usr/$(get_libdir) -lsndfile"
	
	econf \
		$(use_enable altivec) \
		$(use_enable alsa) \
		$(use_enable caps capabilities) $(use_enable caps stripped-jackd) \
		$(use_enable coreaudio) \
		$(use_enable debug) \
		$(use_enable doc html-docs) \
		$(use_enable mmx) \
		$(use_enable oss) \
		$(use_enable sse)  \
		$(use_enable 3dnow dynsimd) \
		$(use_enable jackmidi) \
		--disable-portaudio \
		${myconf} || die "configure failed"
	emake || die "compilation failed"

	if use caps && [[ "${KV:0:3}" == "2.4" ]]; then
		einfo "Building jackstart for 2.4 kernel"
		cd ${S}/jackd
		emake jackstart || die "jackstart build failed."
	fi

	if use netjack; then
		cd "${WORKDIR}/${NETJACK}"
		scons jack_source_dir=${S}
	fi

}

src_install() {
	make DESTDIR=${D} datadir=/usr/share/doc install || die

	if use caps; then
		if [[ "${KV:0:3}" == "2.4" ]]; then
			cd ${S}/jackd
			dobin jackstart
		else
			dosym /usr/bin/jackd /usr/bin/jackstart
		fi
	fi

	if ! use jack-tmpfs; then
		keepdir /var/run/jack
		chmod 4777 ${D}/var/run/jack
	fi

	if use doc; then
		mv ${D}/usr/share/doc/${PF}/reference/html \
		   ${D}/usr/share/doc/${PF}/

		insinto /usr/share/doc/${PF}
		doins -r ${S}/example-clients
	else
		rm -rf ${D}/usr/share/doc
	fi

	rm -rf ${D}/usr/share/doc/${PF}/reference

	if use netjack; then
		cd ${WORKDIR}/${NETJACK}
		dobin alsa_in
		dobin alsa_out
		dobin jacknet_client

		# why on earth doesn't get_libdir work here
		if use amd64; then
			insinto /usr/lib64/jack
		else
			insinto /usr/lib/jack
		fi
		doins jack_net.so
	fi
}
