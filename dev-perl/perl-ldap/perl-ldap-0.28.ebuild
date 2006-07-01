# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE="ssl sasl"

inherit perl-module

DESCRIPTION="A collection of perl modules which provide an object-oriented interface to LDAP servers."
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://perl-ldap.sourceforge.net"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 alpha"

DEPEND="${DEPEND} 
	dev-perl/Convert-ASN1
	dev-perl/URI
	dev-perl/Digest-MD5
	dev-perl/XML-Parser
	dev-perl/XML-SAX
	dev-perl/MIME-Base64
	sasl?	( >=dev-perl/Authen-SASL-2
		dev-perl/Digest-MD5 )
	ssl?	dev-perl/IO-Socket-SSL"
