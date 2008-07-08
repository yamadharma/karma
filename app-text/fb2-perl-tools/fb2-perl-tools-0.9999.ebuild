# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils subversion

DESCRIPTION="Project for creating set of utilities to manage collection of FictionBook2 files"
HOMEPAGE="http://fb2-perl-tools.sourceforge.net"
ESVN_REPO_URI="https://fb2-perl-tools.svn.sourceforge.net/svnroot/fb2-perl-tools"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 ~sh sparc ~x86"
IUSE=""

RDEPEND="dev-perl/XML-Parser
	dev-perl/XML-Writer
	dev-perl/libintl-perl
	dev-perl/Compress-Zlib
	dev-perl/Archive-Zip"
	
DEPEND=""
