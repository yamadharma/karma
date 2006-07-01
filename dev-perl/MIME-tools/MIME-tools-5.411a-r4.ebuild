# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit perl-module

MY_P=${P}-RP-Patched-02

S=${WORKDIR}/${MY_P}

DESCRIPTION="A Perl module for parsing and creating MIME entities"
#SRC_URI="http://www.cpan.org/modules/by-module/MIME/ERYQ/${P}.tar.gz"
SRC_URI="http://www.mimedefang.org/static/${MY_P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/MIME/ERYQ/${P}.readme
http://www.mimedefang.org"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 ppc sparc alpha"

DEPEND="${DEPEND}
	>=dev-perl/IO-stringy-2.108
	dev-perl/MIME-Base64
	dev-perl/libnet
	dev-perl/URI
	dev-perl/Digest-MD5
	dev-perl/libwww-perl
	dev-perl/HTML-Tagset
	dev-perl/HTML-Parser
	dev-perl/MailTools"

