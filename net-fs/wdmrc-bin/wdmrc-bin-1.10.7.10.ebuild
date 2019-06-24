# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

#inherit git-r3 mono-env eutils
inherit mono-env eutils

DESCRIPTION="WebDAV emulator for Mail.ru Cloud"
HOMEPAGE="https://github.com/yar229/WebDavMailRuCloud"
SRC_URI="https://github.com/yar229/WebDavMailRuCloud/releases/download/${PV}/WebDAVCloudMailRu-${PV}-dotNet461.zip"
#SRC_URI="https://github.com/yar229/WebDavMailRuCloud/archive/${PV}.tar.gz -> ${P}.tar.gz"
#EGIT_REPO_URI="https://github.com/yar229/WebDavMailRuCloud"
#EGIT_COMMIT="${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/mono-4.6.2.16
"
RDEPEND=">=dev-lang/mono-4.6.2.16
	!net-fs/wdmrc
"

#S=${WORKDIR}/WebDavMailRuCloud-${PV}
S=${WORKDIR}

src_install() {
	insinto "/usr/$(get_libdir)/${PN}/"
	# doins WDMRC.Console/bin/Release/*
	doins *

	make_wrapper "wdmrc" "mono /usr/$(get_libdir)/${PN}/wdmrc.exe"
}

pkg_info() {
	einfo"- Mount with davfs2"
	einfo "edit /etc/davfs2/davfs2.conf and set use_locks 0"	
	einfo "- CERTIFICATE_VERIFY_FAILED exception"
	einfo "Default installation of Mono doesn’t trust anyone"
	einfo "cat /etc/ssl/certs/* >ca-bundle.crt"
	einfo "cert-sync ca-bundle.crt"
	einfo "rm ca-bundle.crt"
}