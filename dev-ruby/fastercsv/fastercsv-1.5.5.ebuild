# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_DOC="rdoc"
RUBY_FAKEGEM_DOCDIR="doc/html"
RUBY_FAKEGEM_EXTRADOC="AUTHORS CHANGELOG README TODO"

inherit ruby-fakegem

DESCRIPTION="FasterCSV is a replacement for the standard CSV library"
HOMEPAGE="http://fastercsv.rubyforge.org/"
LICENSE="|| ( Ruby GPL-2 )"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

