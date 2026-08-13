# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aead@0.6.1
	aes-gcm@0.11.0
	aes@0.9.2
	aho-corasick@1.1.5
	anstream@1.0.0
	anstyle-parse@1.0.0
	anstyle-query@1.1.5
	anstyle-wincon@3.0.11
	anstyle@1.0.14
	anyhow@1.0.102
	async-broadcast@0.7.2
	async-channel@2.5.0
	async-executor@1.14.0
	async-io@2.6.0
	async-lock@3.4.2
	async-process@2.5.0
	async-recursion@1.1.1
	async-signal@0.2.14
	async-task@4.7.1
	async-trait@0.1.92
	atomic-waker@1.1.2
	atty@0.2.14
	autocfg@1.5.1
	base16ct@1.0.0
	base64@0.22.1
	base64@0.23.1
	base64ct@1.8.3
	bitfield-macros@0.19.5
	bitfield@0.19.5
	bitflags@1.3.2
	bitflags@2.11.0
	block-buffer@0.12.1
	block-padding@0.4.2
	block2@0.6.2
	blocking@1.6.2
	bumpalo@3.20.3
	bytes@1.12.1
	cbc@0.2.1
	cbor4ii@1.2.2
	cc@1.4.2
	cfg-if@1.0.4
	cfg_aliases@0.2.1
	chacha20@0.10.1
	ciborium-io@0.2.2
	ciborium-ll@0.2.2
	ciborium@0.2.2
	cipher@0.5.2
	clap-serde-derive@0.2.1
	clap-serde-proc@0.2.0
	clap@4.6.5
	clap_builder@4.6.5
	clap_complete@4.6.8
	clap_derive@4.6.4
	clap_lex@1.1.0
	cmov@0.5.4
	colorchoice@1.0.5
	concurrent-queue@2.5.0
	const-oid@0.10.2
	const_format@0.2.36
	const_format_proc_macros@0.2.34
	cpubits@0.1.1
	cpufeatures@0.3.0
	crossbeam-utils@0.8.22
	crunchy@0.2.4
	crypto-bigint@0.7.5
	crypto-common@0.2.2
	ctr@0.10.1
	ctrlc@3.5.2
	ctutils@0.4.2
	curve25519-dalek-derive@0.1.1
	curve25519-dalek@5.0.0
	darling@0.24.0
	darling_core@0.24.0
	darling_macro@0.24.0
	defmt-macros@1.1.1
	defmt-parser@1.0.0
	defmt@1.1.1
	der@0.8.1
	deranged@0.5.8
	digest@0.11.2
	dirs-sys@0.5.0
	dirs@6.0.0
	dispatch2@0.3.1
	displaydoc@0.2.7
	ecdsa@0.17.0
	ed25519-dalek@3.0.0
	ed25519@3.0.0
	elliptic-curve@0.14.1
	endi@1.1.1
	enumflags2@0.7.12
	enumflags2_derive@0.7.12
	env_filter@2.0.0
	env_logger@0.11.11
	equivalent@1.0.2
	errno@0.3.14
	event-listener-strategy@0.5.4
	event-listener@5.4.2
	fastrand@2.5.0
	ff@0.14.0
	fiat-crypto@0.3.0
	find-msvc-tools@0.1.10
	form_urlencoded@1.2.2
	futures-core@0.3.34
	futures-io@0.3.34
	futures-lite@2.6.1
	futures-task@0.3.34
	futures-util@0.3.34
	getrandom@0.2.17
	getrandom@0.4.3
	ghash@0.6.0
	git-state@0.1.0
	git2@0.20.4
	git2@0.21.0
	group@0.14.0
	half@1.8.3
	half@2.7.1
	hashbrown@0.17.1
	heck@0.5.0
	hermit-abi@0.1.19
	hermit-abi@0.5.2
	hex@0.4.3
	hidapi@2.6.6
	hkdf@0.13.0
	hmac@0.13.0
	hostname-validator@1.1.1
	hybrid-array@0.4.14
	icu_collections@2.2.0
	icu_locale_core@2.2.0
	icu_normalizer@2.2.0
	icu_normalizer_data@2.2.0
	icu_properties@2.2.0
	icu_properties_data@2.2.0
	icu_provider@2.2.0
	ident_case@1.0.1
	idna@1.1.0
	idna_adapter@1.2.2
	indexmap@2.14.0
	inout@0.2.2
	is_debug@1.1.0
	is_terminal_polyfill@1.70.2
	itoa@1.0.18
	jiff-core@0.1.0
	jiff-static@0.2.35
	jiff-tzdb-platform@0.1.3
	jiff-tzdb@0.1.8
	jiff@0.2.23
	jobserver@0.1.35
	js-sys@0.3.104
	konst@0.2.20
	konst_macro_rules@0.2.19
	lazy_static@1.5.0
	libc@0.2.189
	libgit2-sys@0.18.4+1.9.3
	libredox@0.1.19
	libz-sys@1.1.29
	linux-raw-sys@0.12.1
	litemap@0.8.2
	lock_api@0.4.14
	log@0.4.33
	mac-notification-sys@0.6.15
	mbox@0.7.1
	memchr@2.8.3
	memoffset@0.9.1
	mio@1.2.2
	nix@0.30.1
	nix@0.31.3
	notify-rust@4.18.0
	num-conv@0.2.2
	num-derive@0.4.2
	num-traits@0.2.19
	objc2-core-foundation@0.3.2
	objc2-encode@4.1.0
	objc2-foundation@0.3.2
	objc2@0.6.4
	oid@0.2.1
	once_cell@1.21.4
	once_cell_polyfill@1.70.2
	option-ext@0.2.0
	ordered-stream@0.2.0
	p256@0.14.0
	parking@2.2.1
	pem-rfc7468@1.0.0
	percent-encoding@2.3.2
	picky-asn1-der@0.5.6
	picky-asn1-x509@0.15.4
	picky-asn1@0.10.1
	pin-project-lite@0.2.17
	piper@0.2.5
	pkcs8@0.11.0
	pkg-config@0.3.33
	polling@3.11.0
	polyval@0.7.3
	portable-atomic-util@0.2.7
	portable-atomic@1.15.0
	potential_utf@0.1.5
	powerfmt@0.2.0
	ppv-lite86@0.2.21
	primefield@0.14.0
	primeorder@0.14.0
	proc-macro-crate@3.5.0
	proc-macro2@1.0.107
	procfs-core@0.18.0
	procfs@0.18.0
	prs-lib@0.5.7
	psl-types@2.0.11
	psl@2.1.223
	quote@1.0.47
	r-efi@6.0.0
	rand@0.10.2
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.10.1
	rand_core@0.6.4
	redox_users@0.5.2
	regex-automata@0.4.18
	regex-syntax@0.8.11
	regex@1.13.1
	rfc6979@0.6.0
	rpassword@7.5.4
	rtoolbox@0.0.5
	rustc_version@0.4.1
	rustix@1.1.4
	rustversion@1.0.23
	same-file@1.0.6
	scopeguard@1.2.0
	sec1@0.8.1
	secstr@0.5.1
	semver@1.0.28
	serde@1.0.229
	serde_bytes@0.11.19
	serde_cbor@0.11.2
	serde_core@1.0.229
	serde_derive@1.0.229
	serde_json@1.0.151
	serde_repr@0.1.21
	serde_spanned@1.1.1
	serdect@0.4.3
	sha2@0.11.0
	shadow-rs@2.0.0
	shellexpand@3.1.2
	shlex@1.3.0
	shlex@2.0.1
	signal-hook-registry@1.4.8
	signature@3.0.0
	slab@0.4.12
	smallvec@1.15.2
	socket2@0.6.5
	soft-fido2-crypto@0.17.0
	soft-fido2-ctap@0.17.0
	soft-fido2-transport@0.17.0
	soft-fido2@0.17.0
	spin@0.12.2
	spki@0.8.0
	stable_deref_trait@1.2.1
	strsim@0.11.1
	subtle@2.6.1
	syn@1.0.109
	syn@2.0.119
	syn@3.0.3
	synstructure@0.13.2
	target-lexicon@0.12.16
	tauri-winrt-notification@0.7.2
	tempfile@3.27.0
	thiserror-impl@2.0.20
	thiserror@2.0.19
	time-core@0.1.9
	time@0.3.55
	tinystr@0.8.3
	tokio-macros@2.7.2
	tokio@1.53.1
	toml@1.1.4+spec-1.1.0
	toml_datetime@1.1.1+spec-1.1.0
	toml_edit@0.25.13+spec-1.1.0
	toml_parser@1.1.3+spec-1.1.0
	toml_writer@1.1.2+spec-1.1.0
	tracing-attributes@0.1.31
	tracing-core@0.1.36
	tracing@0.1.44
	tss-esapi-sys@0.6.0
	tss-esapi@7.7.0
	typenum@1.20.1
	uds_windows@1.2.1
	unicode-ident@1.0.24
	unicode-xid@0.2.6
	universal-hash@0.6.1
	url@2.5.8
	utf8_iter@1.0.4
	utf8parse@0.2.2
	uuid@1.24.0
	vcpkg@0.2.15
	version-compare@0.2.1
	walkdir@2.5.0
	wasi@0.11.1+wasi-snapshot-preview1
	wasm-bindgen-macro-support@0.2.127
	wasm-bindgen-macro@0.2.127
	wasm-bindgen-shared@0.2.127
	wasm-bindgen@0.2.127
	which@8.0.5
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
	windows-sys@0.59.0
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
	winnow@1.0.4
	wnaf@0.14.0
	writeable@0.6.3
	yoke-derive@0.8.2
	yoke@0.8.3
	zbus@5.18.0
	zbus_macros@5.19.0
	zbus_names@4.3.4
	zcheapstr@1.1.0
	zerocopy-derive@0.8.56
	zerocopy@0.8.56
	zerofrom-derive@0.1.7
	zerofrom@0.1.8
	zeroize@1.9.0
	zeroize_derive@1.5.0
	zerotrie@0.2.4
	zerovec-derive@0.11.3
	zerovec@0.11.6
	zmij@1.0.23
	zvariant@5.14.0
	zvariant_derive@5.14.0
	zvariant_utils@4.0.0
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
	KEYWORDS="amd64"
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
BDEPEND=""

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
