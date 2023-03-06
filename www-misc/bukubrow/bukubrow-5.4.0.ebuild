# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	ahash-0.4.7
	arrayref-0.3.6
	arrayvec-0.5.2
	atty-0.2.14
	autocfg-1.0.1
	base64-0.13.0
	bitflags-1.2.1
	blake2b_simd-0.5.11
	bumpalo-3.6.1
	byteorder-1.4.2
	cc-1.0.67
	cfg-if-1.0.0
	clap-3.0.0-beta.2
	clap_derive-3.0.0-beta.2
	constant_time_eq-0.1.5
	crossbeam-utils-0.8.3
	dirs-3.0.1
	dirs-sys-0.3.5
	fallible-iterator-0.2.0
	fallible-streaming-iterator-0.1.9
	getrandom-0.1.16
	hashbrown-0.9.1
	hashlink-0.6.0
	heck-0.3.2
	hermit-abi-0.1.18
	indexmap-1.6.1
	itoa-0.4.7
	js-sys-0.3.47
	lazy_static-1.4.0
	libc-0.2.86
	libsqlite3-sys-0.20.1
	log-0.4.14
	memchr-2.3.4
	os_str_bytes-2.4.0
	pkg-config-0.3.19
	platforms-1.1.0
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.24
	quote-1.0.9
	redox_syscall-0.1.57
	redox_users-0.3.5
	rusqlite-0.24.2
	rust-argon2-0.8.3
	ryu-1.0.5
	serde-1.0.123
	serde_derive-1.0.123
	serde_json-1.0.63
	smallvec-1.6.1
	strsim-0.10.0
	syn-1.0.60
	termcolor-1.1.2
	textwrap-0.12.1
	unicode-segmentation-1.7.1
	unicode-width-0.1.8
	unicode-xid-0.2.1
	vcpkg-0.2.11
	vec_map-0.8.2
	version_check-0.9.2
	wasi-0.9.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.70
	wasm-bindgen-backend-0.2.70
	wasm-bindgen-macro-0.2.70
	wasm-bindgen-macro-support-0.2.70
	wasm-bindgen-shared-0.2.70
	web-sys-0.3.47
	webbrowser-0.5.5
	widestring-0.4.3
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	winreg-0.8.0
"

inherit cargo

DESCRIPTION="bukubrow"
# Double check the homepage as the cargo_metadata crate
# does not provide this value so instead repository is used
HOMEPAGE="https://github.com/samhh/bukubrow-host"
SRC_URI="https://github.com/samhh/bukubrow-host/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris)"
# License set may be more restrictive as OR is not respected
# use cargo-license for a more accurate license picture
LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 Boost-1.0 CC0-1.0 MIT Unlicense"
SLOT="0"
KEYWORDS="amd64"
RESTRICT="primaryuri"
S="${WORKDIR}/${PN}-host-${PV}"
