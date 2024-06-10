# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm

DESCRIPTION="Russian Root CA"
HOMEPAGE="https://www.gosuslugi.ru/crt"
#SRC_URI="https://gu-st.ru/content/Other/doc/russian_trusted_root_ca.cer -> ${P}.cer"
SRC_URI="https://git.altlinux.org/tasks/318769/build/100/x86_64/rpms/ca-certificates-digital.gov.ru-1.1-alt1.noarch.rpm"

LICENSE="all-rights-reserved"
KEYWORDS="amd64"
SLOT="0"


RDEPEND="
	dev-libs/openssl
"

S=${WORKDIR}

#src_unpack () {
#	cd ${WORKDIR}
#	mkdir ${P}
#	cp ${DISTDIR}/${P}.cer ${P}
#}

src_install () {
	cd ${S}/usr/share/pki/ca-trust-source/anchors
	for i in *.cer
	do
		# openssl x509 -inform DER -in ${i} -out ${i/.cer/.crt}
		mv ${i} ${i/.cer/.crt}
	done
	insinto /usr/local/share/ca-certificates/
	doins *.crt
}

pkg_postinst () {
	update-ca-certificates
}