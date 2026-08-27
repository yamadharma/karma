# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit cargo meson

RUST_MIN_VER="1.77.0"
CRATES="
	anstream@0.6.18
	anstyle-parse@0.2.6
	anstyle-query@1.1.2
	anstyle-wincon@3.0.6
	anstyle@1.0.10
	ash@0.38.0+1.3.281
	autocfg@1.4.0
	bitflags@2.6.0
	cfg-if@1.0.0
	cfg_aliases@0.2.1
	clap@4.5.21
	clap_builder@4.5.21
	clap_lex@0.7.3
	colorchoice@1.0.3
	getrandom@0.2.15
	is_terminal_polyfill@1.70.1
	libc@0.2.177
	libloading@0.8.5
	log@0.4.22
	memoffset@0.9.1
	nix@0.30.1
	pkg-config@0.3.31
	strsim@0.11.1
	utf8parse@0.2.2
	wasi@0.11.0+wasi-snapshot-preview1
	windows-sys@0.59.0
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.52.6
"

DESCRIPTION="Transparent network proxy for Wayland compositors"
HOMEPAGE="https://gitlab.freedesktop.org/mstoeckl/waypipe"

SRC_URI="
	https://gitlab.freedesktop.org/mstoeckl/waypipe/-/archive/v${PV}/${P}.tar.gz
	${CARGO_CRATE_URIS}
"
S=${WORKDIR}/${PN}-v${PV}-a1ffdd8d0f44cbdb25a3edd1c6adc0a30cfcf754

LICENSE="GPL-3+"
# Dependent crate licenses
LICENSE+=" ISC MIT"
SLOT="0"
# KEYWORDS="~amd64"

# assuming vaapi is still required for video
IUSE="debug +gbm ffmpeg +lz4 +man test vaapi +vulkan +zstd"
REQUIRED_USE=" || ( vulkan gbm )"

# alternatives to openssh not tested.
# is vulkan dep on mesa enough?

# shuffled use flags from c version a bit to
# follow upstream wording:
# 	dmabuf: true	is the vulkan enabled version,
# 	dmabuf: gbm		is the mesa fallback.
# which is media-libs/mesa[opengl]?
# test, debug not wired up. both want vulkan-layers for a start.

DEPEND="
	virtual/openssh
	lz4? ( app-arch/lz4 )
	zstd? ( app-arch/zstd )
	gbm? (
		media-libs/mesa[opengl,vaapi?,wayland]
		x11-libs/libdrm
	)
	vulkan? ( media-libs/mesa[vaapi?,vulkan,wayland] )
	vaapi? ( media-libs/libva[drm(+),wayland] )
	ffmpeg? ( media-video/ffmpeg:=[x264,vaapi?] )
	debug? ( media-libs/vulkan-layers )
"

BDEPEND="
	${DEPEND}
	dev-util/bindgen
	virtual/pkgconfig
	man? ( app-text/scdoc )
	test? (
		media-libs/vulkan-layers
	)

"
# test? dev-libs/weston[examples,headless,remoting,screen-sharing,wayland-compositor]

RDEPEND="${DEPEND}"

src_configure() {
	local emesonargs=(
		$(meson_feature vulkan with_dmabuf)
		$(meson_feature ffmpeg with_video)
		$(meson_feature lz4 with_lz4)
		$(meson_feature zstd with_zstd)
		$(meson_feature man man-pages)
	)
	meson_src_configure
}