# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic eutils multilib subversion autotools

NETJACK="netjack-0.12"

RESTRICT="nostrip nomirror"
DESCRIPTION="A low-latency audio server"
HOMEPAGE="http://www.jackaudio.org"
SRC_URI="netjack? ( mirror://sourceforge/netjack/${NETJACK}.tar.bz2 )"

ESVN_OPTIONS="-r{${PV/*_pre}}"
ESVN_REPO_URI="http://subversion.jackaudio.org/jack/trunk/jack"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="altivec alsa caps coreaudio doc debug jack-tmpfs mmx oss sndfile netjack
sse jackmidi
3dnow"

RDEPEND="dev-util/pkgconfig
	netjack? ( !media-sound/netjack )
	sndfile? ( >=media-libs/libsndfile-1.0.0 )
	sys-libs/ncurses
	caps? ( sys-libs/libcap )
	alsa? ( >=media-libs/alsa-lib-0.9.1 )
	netjack? ( dev-util/scons )
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
	use netjack && cd ${WORKDIR} &&  unpack ${A}
	cd ${S}
	
	# the docs option is in upstream, I'll leave the pentium2 foobage
	# for the x86 folks...... kito@gentoo.org

	# Add doc option and fix --march=pentium2 in caps test
	#epatch ${FILESDIR}/${PN}-doc-option.patch

	# compile and install jackstart, see #92895, #94887
	#if use caps ; then
	#	epatch ${FILESDIR}/${PN}-0.99.0-jackstart.patch
	#fi

	epatch ${FILESDIR}/${PN}-transport.patch
	#if use jackmidi; then
	#	epatch ${FILESDIR}/jackmidi_01dec05.patch || die
	#fi
}

src_compile() {
	sed -i -e "s:include/nptl/:include/:g" configure.ac || die
	#NOCONFIGURE="1" ./autogen.sh
	eautoreconf
	
	local myconf

	sed -i "s/^CFLAGS=\$JACK_CFLAGS/CFLAGS=\"\$JACK_CFLAGS $(get-flag -march)\"/" configure || die

	use doc && myconf="--with-html-dir=/usr/share/doc/${PF}"

	if use jack-tmpfs; then
		myconf="${myconf} --with-default-tmpdir=/dev/shm"
	else
		myconf="${myconf} --with-default-tmpdir=/var/run/jack"
	fi

	if use userland_Darwin ; then
		append-flags -fno-common
		use altivec && append-flags -force_cpusubtype_ALL \
			-maltivec -mabi=altivec -mhard-float -mpowerpc-gfxopt
	fi

	if use jackmidi; then
		aclocal
		automake
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
		--with-pic \
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
		insinto /usr/lib/jack
		doins jack_net.so
	fi
}
