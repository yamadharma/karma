# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_EXTRADOC="README.md CHANGELOG.md"

inherit ruby-fakegem

DESCRIPTION="A Liquid block tag which makes it easy to wrap an include, render or yield tag with html"
HOMEPAGE="https://github.com/octopress/wrap-tag"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend "www-apps/octopress-tag-helpers
	www-apps/octopress-include-tag
	www-apps/octopress-render-tag
	www-apps/octopress-content-for
	www-apps/octopress-return-tag
	www-apps/jekyll
"

ruby_add_bdepend "test? ( www-apps/octopress
	www-apps/octopress-ink
	dev-ruby/bundler
	dev-ruby/clash
	dev-ruby/rake
	www-apps/octopress-debugger )"
