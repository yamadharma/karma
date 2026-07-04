# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aead@0.5.2
	aes-gcm@0.10.3
	aes@0.8.4
	aes@0.9.0
	aho-corasick@1.1.4
	anstream@1.0.0
	anstyle-parse@1.0.0
	anstyle-query@1.1.5
	anstyle-wincon@3.0.11
	anstyle@1.0.13
	anyhow@1.0.102
	async-broadcast@0.7.2
	async-channel@2.5.0
	async-executor@1.14.0
	async-io@2.6.0
	async-lock@3.4.2
	async-process@2.5.0
	async-recursion@1.1.1
	async-signal@0.2.13
	async-task@4.7.1
	async-trait@0.1.89
	atomic-waker@1.1.2
	atty@0.2.14
	autocfg@1.5.0
	base16ct@0.2.0
	base64@0.22.1
	base64ct@1.8.3
	bitfield-macros@0.19.4
	bitfield@0.19.4
	bitflags@2.11.0
	block-buffer@0.10.4
	block-buffer@0.12.0
	block-padding@0.4.2
	block2@0.6.2
	blocking@1.6.2
	bumpalo@3.20.2
	cbc@0.2.1
	cbor4ii@1.2.2
	cc@1.2.56
	cfg-if@1.0.4
	cfg_aliases@0.2.1
	ciborium-io@0.2.2
	ciborium-ll@0.2.2
	ciborium@0.2.2
	cipher@0.4.4
	cipher@0.5.2
	clap-serde-derive@0.2.1
	clap-serde-proc@0.2.0
	clap@4.6.1
	clap_builder@4.6.0
	clap_complete@4.6.5
	clap_derive@4.6.1
	clap_lex@1.0.0
	cmov@0.5.2
	colorchoice@1.0.4
	concurrent-queue@2.5.0
	const-oid@0.10.2
	const-oid@0.9.6
	const_format@0.2.35
	const_format_proc_macros@0.2.34
	cpubits@0.1.1
	cpufeatures@0.2.17
	cpufeatures@0.3.0
	crossbeam-utils@0.8.21
	crunchy@0.2.4
	crypto-bigint@0.5.5
	crypto-common@0.1.7
	crypto-common@0.2.2
	ctr@0.9.2
	ctrlc@3.5.2
	ctutils@0.4.0
	curve25519-dalek-derive@0.1.1
	curve25519-dalek@4.1.3
	darling@0.23.0
	darling_core@0.23.0
	darling_macro@0.23.0
	der@0.7.10
	deranged@0.5.8
	digest@0.10.7
	digest@0.11.2
	dirs-sys@0.5.0
	dirs@6.0.0
	dispatch2@0.3.1
	displaydoc@0.2.5
	ecdsa@0.16.9
	ed25519-dalek@2.2.0
	ed25519@2.2.3
	elliptic-curve@0.13.8
	endi@1.1.1
	enumflags2@0.7.12
	enumflags2_derive@0.7.12
	env_filter@1.0.0
	env_logger@0.11.10
	equivalent@1.0.2
	errno@0.3.14
	event-listener-strategy@0.5.4
	event-listener@5.4.1
	fastrand@2.3.0
	ff@0.13.1
	fiat-crypto@0.2.9
	find-msvc-tools@0.1.9
	foldhash@0.1.5
	form_urlencoded@1.2.2
	futures-core@0.3.32
	futures-io@0.3.32
	futures-lite@2.6.1
	generic-array@0.14.7
	getrandom@0.2.17
	getrandom@0.3.4
	getrandom@0.4.2
	ghash@0.5.1
	git-state@0.1.0
	git2@0.20.4
	git2@0.21.0
	group@0.13.0
	half@1.8.3
	half@2.7.1
	hashbrown@0.15.5
	hashbrown@0.16.1
	heck@0.5.0
	hermit-abi@0.1.19
	hermit-abi@0.5.2
	hex@0.4.3
	hidapi@2.6.5
	hkdf@0.12.4
	hkdf@0.13.0
	hmac@0.12.1
	hmac@0.13.0
	hostname-validator@1.1.1
	hybrid-array@0.4.8
	icu_collections@2.1.1
	icu_locale_core@2.1.1
	icu_normalizer@2.1.1
	icu_normalizer_data@2.1.1
	icu_properties@2.1.2
	icu_properties_data@2.1.2
	icu_provider@2.1.1
	id-arena@2.3.0
	ident_case@1.0.1
	idna@1.1.0
	idna_adapter@1.2.1
	indexmap@2.13.0
	inout@0.1.4
	inout@0.2.2
	is_debug@1.1.0
	is_terminal_polyfill@1.70.2
	itoa@1.0.17
	jiff-static@0.2.23
	jiff-tzdb-platform@0.1.3
	jiff-tzdb@0.1.6
	jiff@0.2.23
	jobserver@0.1.34
	js-sys@0.3.91
	lazy_static@1.5.0
	leb128fmt@0.1.0
	libc@0.2.186
	libgit2-sys@0.18.4+1.9.3
	libredox@0.1.14
	libz-sys@1.1.25
	linux-raw-sys@0.12.1
	litemap@0.8.1
	lock_api@0.4.14
	log@0.4.30
	mac-notification-sys@0.6.12
	mbox@0.7.1
	memchr@2.8.0
	memoffset@0.9.1
	nix@0.30.1
	nix@0.31.3
	notify-rust@4.17.0
	num-conv@0.2.0
	num-derive@0.4.2
	num-traits@0.2.19
	objc2-core-foundation@0.3.2
	objc2-encode@4.1.0
	objc2-foundation@0.3.2
	objc2@0.6.4
	oid@0.2.1
	once_cell@1.21.3
	once_cell_polyfill@1.70.2
	opaque-debug@0.3.1
	option-ext@0.2.0
	ordered-stream@0.2.0
	p256@0.13.2
	parking@2.2.1
	pem-rfc7468@0.7.0
	percent-encoding@2.3.2
	picky-asn1-der@0.5.6
	picky-asn1-x509@0.15.4
	picky-asn1@0.10.1
	pin-project-lite@0.2.17
	piper@0.2.5
	pkcs8@0.10.2
	pkg-config@0.3.32
	polling@3.11.0
	polyval@0.6.2
	portable-atomic-util@0.2.5
	portable-atomic@1.13.1
	potential_utf@0.1.4
	powerfmt@0.2.0
	ppv-lite86@0.2.21
	prettyplease@0.2.37
	primeorder@0.13.6
	proc-macro-crate@3.5.0
	proc-macro2@1.0.106
	procfs-core@0.18.0
	procfs@0.18.0
	prs-lib@0.5.7
	quick-xml@0.37.5
	quote@1.0.45
	r-efi@5.3.0
	r-efi@6.0.0
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	redox_users@0.5.2
	regex-automata@0.4.14
	regex-syntax@0.8.10
	regex@1.12.3
	rfc6979@0.4.0
	rpassword@7.5.3
	rtoolbox@0.0.3
	rustc_version@0.4.1
	rustix@1.1.4
	rustversion@1.0.22
	same-file@1.0.6
	scopeguard@1.2.0
	sec1@0.7.3
	secstr@0.5.1
	semver@1.0.27
	serde@1.0.228
	serde_bytes@0.11.19
	serde_cbor@0.11.2
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.150
	serde_repr@0.1.20
	serde_spanned@1.1.1
	sha2@0.10.9
	sha2@0.11.0
	shadow-rs@2.0.0
	shellexpand@3.1.2
	shlex@1.3.0
	signal-hook-registry@1.4.8
	signature@2.2.0
	slab@0.4.12
	smallvec@1.15.1
	soft-fido2-crypto@0.13.0
	soft-fido2-ctap@0.13.0
	soft-fido2-transport@0.13.0
	soft-fido2@0.13.0
	spin@0.11.0
	spki@0.7.3
	stable_deref_trait@1.2.1
	strsim@0.11.1
	subtle@2.6.1
	syn@1.0.109
	syn@2.0.117
	synstructure@0.13.2
	target-lexicon@0.12.16
	tauri-winrt-notification@0.7.2
	tempfile@3.27.0
	thiserror-impl@2.0.18
	thiserror@2.0.18
	time-core@0.1.8
	time@0.3.47
	tinystr@0.8.2
	toml@1.1.2+spec-1.1.0
	toml_datetime@1.1.1+spec-1.1.0
	toml_edit@0.25.4+spec-1.1.0
	toml_parser@1.1.2+spec-1.1.0
	toml_writer@1.1.1+spec-1.1.0
	tracing-attributes@0.1.31
	tracing-core@0.1.36
	tracing@0.1.44
	tss-esapi-sys@0.6.0
	tss-esapi@7.7.0
	typenum@1.19.0
	uds_windows@1.2.0
	unicode-ident@1.0.24
	unicode-xid@0.2.6
	universal-hash@0.5.1
	url@2.5.8
	utf8_iter@1.0.4
	utf8parse@0.2.2
	uuid@1.22.0
	vcpkg@0.2.15
	version-compare@0.2.1
	version_check@0.9.5
	walkdir@2.5.0
	wasi@0.11.1+wasi-snapshot-preview1
	wasip2@1.0.2+wasi-0.2.9
	wasip3@0.4.0+wasi-0.3.0-rc-2026-01-06
	wasm-bindgen-macro-support@0.2.114
	wasm-bindgen-macro@0.2.114
	wasm-bindgen-shared@0.2.114
	wasm-bindgen@0.2.114
	wasm-encoder@0.244.0
	wasm-metadata@0.244.0
	wasmparser@0.244.0
	which@8.0.2
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.11
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-collections@0.2.0
	windows-core@0.61.2
	windows-future@0.2.1
	windows-implement@0.60.2
	windows-interface@0.59.3
	windows-link@0.1.3
	windows-link@0.2.1
	windows-numerics@0.2.0
	windows-result@0.3.4
	windows-strings@0.4.2
	windows-sys@0.52.0
	windows-sys@0.61.2
	windows-targets@0.52.6
	windows-threading@0.1.0
	windows-version@0.1.7
	windows@0.61.3
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.52.6
	winnow@0.7.15
	winnow@1.0.0
	wit-bindgen-core@0.51.0
	wit-bindgen-rust-macro@0.51.0
	wit-bindgen-rust@0.51.0
	wit-bindgen@0.51.0
	wit-component@0.244.0
	wit-parser@0.244.0
	writeable@0.6.2
	yoke-derive@0.8.1
	yoke@0.8.1
	zbus@5.14.0
	zbus_macros@5.14.0
	zbus_names@4.3.1
	zerocopy-derive@0.8.42
	zerocopy@0.8.42
	zerofrom-derive@0.1.6
	zerofrom@0.1.6
	zeroize@1.8.2
	zeroize_derive@1.4.3
	zerotrie@0.2.3
	zerovec-derive@0.11.2
	zerovec@0.11.5
	zmij@1.0.21
	zvariant@5.10.0
	zvariant_derive@5.10.0
	zvariant_utils@3.3.0
"

inherit cargo systemd udev

DESCRIPTION="FIDO2 security token emulator"
HOMEPAGE="https://github.com/pando85/passless"
SRC_URI="
	${CARGO_CRATE_URIS}
"
if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/pando85/passless.git"
	inherit git-r3
	SRC_URI=+""
	# KEYWORDS="~amd64"
else
	SRC_URI+="https://github.com/pando85/passless/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
# Dependent crate licenses
LICENSE+="
	AGPL-3+ Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD LGPL-3 MIT
	MPL-2.0 Unicode-3.0 Unlicense ZLIB
"
SLOT="0"
IUSE="+tpm"

DEPEND="
	virtual/libudev
	acct-group/fido
	tpm? ( app-crypt/tpm2-tss )
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/cargo
	virtual/rust
"

src_compile() {
	local myfeatures=()
	use tpm && myfeatures+=( "tpm" )

	export RUSTUP_TOOLCHAIN=stable
	export CARGO_TARGET_DIR=target
	export LIBGIT2_SYS_USE_PKG_CONFIG=1
	export LIBGIT2_NO_VENDOR=1
	export HIDAPI_SYS_USE_PKG_CONFIG=1
	export HIDAPI_LIBRARIES=hidapi-hidraw
	export RUSTFLAGS="-C link-arg=-lhidapi-hidraw"

	cargo_src_compile $(usev tpm "--features tpm")
}

src_install() {
	# cargo_src_install

	dobin ${S}/target/release/passless

	# systemd user-служба
	systemd_douserunit contrib/systemd/passless.service

	# udev-правило для доступа к /dev/uhid через группу fido
	udev_dorules contrib/udev/90-passless.rules

	# modules-load.d для автозагрузки uhid
	insinto /lib/modules-load.d
	doins contrib/modules-load.d/fido.conf

	# конфигурация по умолчанию (опционально)
	insinto /etc/passless
	newins - config.toml <<-EOF
		[pin]
		enforcement = "optional"
		min_length = 4
		max_retries = 8
	EOF

	# Install shell completions
	local _completion_dir="$(find target/release/build/passless-rs-*/out/completions -type d 2>/dev/null | head -1)"
	if [ -n "$_completion_dir" ]; then
		dodir /usr/share/bash-completion/completions
		install -Dm0644 "${_completion_dir}/passless.bash" \
				"${D}/usr/share/bash-completion/completions/passless"
		dodir /usr/share/fish/vendor_completions.d
		install -Dm0644 "${_completion_dir}/passless.fish" \
				"${D}/usr/share/fish/vendor_completions.d/passless.fish"
		dodir /usr/share/zsh/site-functions
		install -Dm0644 "${_completion_dir}/_passless" \
				"${D}/usr/share/zsh/site-functions/_passless"
		dodir /usr/share/elvish/lib
		install -Dm0644 "${_completion_dir}/passless.elv" \
			"${D}/usr/share/elvish/lib/passless.elv"
	fi

}

pkg_postinst() {
	udev_reload
	systemd_user_service_reload

	elog "To use passless:"
	elog " 1. Add yourself to the fido group:"
	elog " usermod -aG fido ${USER}"
	elog " 2. Load the uhid kernel module (or reboot):"
	elog " modprobe uhid"
	elog " 3. Start the systemd service (user):"
	elog " systemctl --user enable --now passless.service"
	elog
	elog "If you are using a TPM backend, set the USE=tpm flag."
	elog "To configure, edit /etc/passless/config.toml"
}
