# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Russian Root CA"
HOMEPAGE="https://www.gosuslugi.ru/crt"
SRC_URI="https://gu-st.ru/content/Other/doc/russian_trusted_root_ca.cer -> ${P}.cer"

LICENSE="all-rights-reserved"
KEYWORDS="amd64"
SLOT="0"


RDEPEND="
	dev-libs/openssl
"

src_unpack () {
	cd ${WORKDIR}
	mkdir ${P}
	cp ${DISTDIR}/${P}.cer ${P}
}

src_install () {
	openssl x509 -inform DER -in ${P}.cer -out ${PN}.crt
	dodir /usr/local/share/ca-certificates/
	cp ${PN}.crt ${D}/usr/local/share/ca-certificates/
}

pkg_postinst () {
	update-ca-certificates
}