# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=${PN/-bin/}
inherit unpacker bash-completion-r1

DESCRIPTION="Tool for building and distributing virtual machines"
HOMEPAGE="http://vagrantup.com/"

# SRC_URI_AMD64="https://releases.hashicorp.com/${MY_PN}/${PV}/${MY_PN}_${PV}_x86_64.deb"
# SRC_URI_X86="https://releases.hashicorp.com/${MY_PN}/${PV}/${MY_PN}_${PV}_i686.deb"
SRC_URI="
	amd64? ( https://hashicorp-releases.yandexcloud.net/vagrant/${PV}/vagrant_${PV}-1_amd64.deb )
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

S="${WORKDIR}/opt/${MY_PN}"

DEPEND=""
RDEPEND="${DEPEND}
	app-arch/libarchive
	net-misc/curl
	!app-emulation/vagrant
"

RESTRICT="mirror"

src_unpack() {
	unpack_deb ${A}
}

src_install() {
#	pushd embedded/gems/${PV}/gems/${MY_PN}-${PV}/contrib > /dev/null || die
	pushd embedded/gems/gems/${MY_PN}-${PV}/contrib > /dev/null || die
	insinto /usr/share/vim/vimfiles/plugin
	doins vim/*
	popd > /dev/null || die

	local dir="/opt/${MY_PN}"
	dodir ${dir}
	cp -ar ./* "${ED}${dir}" || die "copy files failed"

	make_wrapper "${MY_PN}" "${dir}/bin/${MY_PN}"

	dosym /opt/vagrant/vagrant /usr/bin/vagrant
	dosym /opt/vagrant/vagrant-go /usr/bin/vagrant-go
}
