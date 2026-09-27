# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo systemd udev

DESCRIPTION="FIDO2 security token emulator"
HOMEPAGE="https://github.com/pando85/passless"
SRC_URI="
https://github.com/pando85/passless/releases/download/v${PV}/vendor.tar.gz -> passless-vendor-${PV}.tar.gz
"
ECARGO_VENDOR="${WORKDIR}/vendor"

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
