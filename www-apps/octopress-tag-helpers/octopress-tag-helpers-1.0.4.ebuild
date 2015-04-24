# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_EXTRADOC="README.md CHANGELOG.md"

inherit ruby-fakegem

DESCRIPTION="Making it easier to build smart Jekyll/Octopress Liquid tags"
HOMEPAGE="https://github.com/octopress/tag-helpers"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend "www-apps/jekyll"

ruby_add_bdepend "test? ( dev-ruby/bundler
	dev-ruby/clash
	dev-ruby/rake
	www-apps/octopress-debugger )"
