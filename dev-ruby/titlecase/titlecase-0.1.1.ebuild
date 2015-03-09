# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/crass/crass-1.0.1.ebuild,v 1.2 2015/01/31 17:25:53 graaff Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_EXTRADOC="README"

inherit ruby-fakegem

DESCRIPTION="titlecase is a set of methods on the Ruby String class to add title casing support as seen on Daring Fireball"
HOMEPAGE="http://github.com/samsouder/titlecase"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
