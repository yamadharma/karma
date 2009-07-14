# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild come from voip overlay.

EAPI="2"

inherit autotools eutils flag-o-matic

DESCRIPTION="C++ class library normalising numerous telephony protocols"
HOMEPAGE="http://www.opalvoip.org/"
SRC_URI="mirror://sourceforge/opalvoip/${P}.tar.bz2
	doc? ( mirror://sourceforge/opalvoip/${P}-htmldoc.tar.bz2 )"

LICENSE="MPL-1.0"
SLOT="0"
KEYWORDS="~ppc ~x86 ~amd64"
IUSE="+audio capi debug dns doc dtmf examples fax ffmpeg g711plc h224 +h323 iax
ipv6 ivr ixj java ldap lid +plugins rfc4175 +sip srtp ssl stats theora +video
vpb vxml wav x264 x264-static xml"

RDEPEND=">=net-libs/ptlib-2.0.0[debug=,audio?,dns?,dtmf?,ipv6?,ldap?,ssl?,video?,vxml?,wav?,xml?]
	>=media-libs/speex-1.2_beta
	fax? ( net-libs/ptlib[asn] )
	ivr? ( net-libs/ptlib[xml,vxml] )
	java? ( virtual/jdk )
	plugins? ( media-sound/gsm
		capi? ( net-dialup/capi4k-utils )
		fax? ( media-libs/spandsp )
		ffmpeg? ( >=media-video/ffmpeg-0.4.7[encode] )
		ixj? ( sys-kernel/linux-headers )
		theora? ( media-libs/libtheora )
		x264? (	>=media-video/ffmpeg-0.4.7
			media-libs/x264 ) )
	srtp? ( net-libs/libsrtp )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=sys-devel/gcc-3"

# NOTES:
# need speexdsp, that means >=speex-1.2
# ffmpeg[encode] is for h263, h263p and mpeg4
# fax enable fax, t38 and spandsp support
# h323 auto-enables h450, h460 and h501 wich provide supplementary services
# ssl, xml, vxml, ipv6, dtmf, ldap, audio, wav, dns and video are use flags
#   herited from ptlib: feature is enabled if ptlib has enabled it
#   however, disabling it if ptlib has it looks hard (coz of buildopts.h)
#   forcing ptlib to disable it for opal is not a solution too
#   atm, accepting the "auto-feature" looks like a good solution
#   asn is used for fax and config for examples
# OPALDIR should not be used anymore, if a package still need it, create it

pkg_setup() {
	local warning=false

	# opal can't be built with --as-needed
	# users where experiencing issues with --as-needed, see bug 238610
	# TODO: should be re-tested and, if possible, fixed in a cleanier way
	append-ldflags -Wl,--no-as-needed

	# warn user about use flag that are gonna override other ones

	if ! use plugins; then
		ewarn "disabling plugins will automatialy disable a lot of ${PN} features"
		ewarn "like gsm, capi, spandsp, ffmpeg, ixj, theora and x264"
		ewarn "it is _not_ recommended"
		warning=true
	fi

	if use h224 && ! use h323; then
		ewarn "h224 support needs h323 support: h224 support has been disabled"
		ewarn "enable h323 support if you want to use the h224 support"
		warning=true
	fi

	if use rfc4175 && ! use video; then
		ewarn "rfc4175 support needs video support: rfc4175 support has been disabled"
		ewarn "enable video support if you want to use the rfc4175 support"
		warning=true
	fi

	if use x264-static && ! use x264; then
		ewarn "x264-static has been enabled but x264 support has been disabled"
	fi

	if ${warning}; then
		echo
		ewarn "If one of the warnings above is not volunteer, hit Ctrl+C now"
		ewarn "and re-emerge ${PN} with the desired USE flags"
		echo
		ebeep
		epause
	fi
}

src_prepare() {
	# move files from ${P}-htmldoc.tar.gz
	if use doc; then
		mv ../html . || die "moving doc files failed"
	fi

	# remove visual studio related files from samples/
	if use examples; then
		rm -f samples/*/*.vcproj
		rm -f samples/*/*.sln
		rm -f samples/*/*.dsp
		rm -f samples/*/*.dsw
	fi

	# h501 is in configure.ac but not in configure, updating the script
	# upstream has been contacted, bug 2686483 in their bugtracker
	#eautoreconf

	# disable srtp if srtp is not enabled (prevent auto magic dep)
	# upstream has been contacted, bug 2686485 in their bugtracker
	if ! use srtp; then
		sed -i -e "s/OPAL_SRTP=yes/OPAL_SRTP=no/" configure \
			|| die "patching configure failed"
	fi

	# disable theora if theora is not enabled (prevent auto magic dep)
	# upstream has been contacted, bug 2686488 in their bugtracker
	if ! use theora; then
		sed -i -e "s/HAVE_THEORA=yes/HAVE_THEORA=no/" plugins/configure \
			|| die "patching plugins/configure failed"
	fi

	# Disable mpeg4, can't find include, need to fix
	sed -i -e "s/HAVE_MPEG4=yes/HAVE_MPEG4=no/" plugins/configure \
		|| die "patching plugins/configure failed"
	# disable mpeg4 and h263p if ffmpeg is not enabled (prevent auto magic dep)
	# upstream has been contacted, bug 2686495 in their bugtracker
	
	if ! use ffmpeg; then
		sed -i -e "s/HAVE_MPEG4=yes/HAVE_MPEG4=no/" plugins/configure \
			|| die "patching plugins/configure failed"
		sed -i -e "s/HAVE_H263P=yes/HAVE_H263P=no/" plugins/configure \
			|| die "patching plugins/configure failed"
	fi

	# fix gsm wav49 support check
	# upstream has been contacted, bug 2686500 in their bugtracker
	if use plugins; then
		sed -i -e "s:gsm\.h:gsm/gsm.h:" plugins/configure \
			|| die "patching plugins/configure failed"
	fi
}

src_configure() {
	local myconf=""

	if use ffmpeg; then
		# with-libavcodec-source-dir: no default value
		myconf="--with-libavcodec-source-dir=/usr/include"
	fi

	# versioncheck: check for ptlib version
	# shared: should always be enabled for a lib
	# zrtp doesn't depend on net-libs/libzrtpcpp but on libzrtp from
	# 	http://zfoneproject.com/ wich is not in portage
	# localspeex, localspeexdsp, localgsm: never use bundled libs
	# samples: only build some samples, useless
	# libavcodec-stackalign-hack: prevent hack (default disable by upstream)
	# default-to-full-capabilties: default enable by upstream
	# aec: atm, only used when bundled speex, so it's painless for us
	econf ${myconf} \
		--enable-versioncheck \
		--enable-shared \
		--disable-zrtp \
		--disable-localspeex \
		--disable-localspeexdsp \
		--disable-localgsm \
		--disable-samples \
		--disable-libavcodec-stackalign-hack \
		--enable-default-to-full-capabilties \
		--enable-aec \
		$(use_enable debug) \
		$(use_enable capi) \
		$(use_enable fax) \
		$(use_enable fax spandsp) \
		$(use_enable fax t38) \
		$(use_enable ffmpeg ffmpeg-h263) \
		$(use_enable g711plc) \
		$(use_enable h224) \
		$(use_enable h323) \
		$(use_enable h323 h450) \
		$(use_enable h323 h460) \
		$(use_enable h323 h501) \
		$(use_enable iax) \
		$(use_enable ivr) \
		$(use_enable ixj) \
		$(use_enable java) \
		$(use_enable lid) \
		$(use_enable plugins) \
		$(use_enable rfc4175) \
		$(use_enable sip) \
		$(use_enable stats statistics) \
		$(use_enable video) \
		$(use_enable vpb) \
		$(use_enable x264 h264) \
		$(use_enable x264-static x264-link-static)
}

src_compile() {
	local makeopts=""

	use debug && makeopts="debug"

	emake ${makeopts} || die "emake failed"
}

src_install() {
	einstall || die "einstall failed"

	if use doc; then
		dohtml -r html/* docs/* || die "dohtml failed"
	fi

	dodoc ChangeLog-${PN}-v${PV//./_}.txt || die "dodoc failed"

	if use examples; then
		local exampledir="/usr/share/doc/${PF}/examples"
		local basedir="samples"
		local sampledirs="`ls ${basedir} --hide=configure* \
			--hide=opal_samples* --hide=config.*`"

		# first, install files
		insinto ${exampledir}/
		doins ${basedir}/{configure*,opal_samples*,config.*} \
			|| die "doins failed"

		# now, all examples
		for x in ${sampledirs}; do
			insinto ${exampledir}/${x}/
			doins ${basedir}/${x}/* || die "doins failed"
		done

		# some examples need version.h
		insinto "/usr/share/doc/${PF}/"
		doins version.h || die "doins failed"
	fi
}

pkg_postinst() {
	if use examples; then
		ewarn "all examples have been installed, some of them will not work on your system"
		ewarn "it will depend of the enabled use flags in ptlib and opal"
	fi
}

