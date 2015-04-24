# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/colorator/colorator-0.1-r1.ebuild,v 1.3 2015/02/25 18:02:33 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_EXTRAINSTALL="assets"

inherit ruby-fakegem

DESCRIPTION="A Jekyll theme built on Octopress Ink."
HOMEPAGE="https://github.com/octopress/genesis-theme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend "www-apps/octopress-ink
	www-apps/octopress-linkblog
	www-apps/octopress-date-format
	www-apps/octopress-paginate
	www-apps/octopress-autoprefixer
	www-apps/octopress-wrap-tag
	www-apps/octopress-assign-tag
	www-apps/octopress-filter-tag
	www-apps/octopress-comment-tag
	www-apps/octopress-quote-tag
	www-apps/octopress-social
	dev-ruby/sass
"

ruby_add_bdepend "test? ( www-apps/octopress
	dev-ruby/bundler
	dev-ruby/rake
	dev-ruby/clash
	www-apps/octopress-debugger )"
