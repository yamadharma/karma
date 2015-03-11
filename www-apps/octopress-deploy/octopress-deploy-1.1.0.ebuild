# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/colorator/colorator-0.1-r1.ebuild,v 1.3 2015/02/25 18:02:33 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_EXTRADOC="README.md"
# RUBY_FAKEGEM_RECIPE_DOC="rdoc"
# RUBY_FAKEGEM_RECIPE_TEST="rspec"

inherit ruby-fakegem

DESCRIPTION="Easily deploy any Jekyll or Octopress site using S3, Git, or Rsync."
HOMEPAGE="https://github.com/octopress/deploy"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend "dev-ruby/colorator
	dev-ruby/aws-sdk"

ruby_add_bdepend "test? ( www-apps/octopress
	dev-ruby/bundler
	dev-ruby/clash
	dev-ruby/rake
	dev-ruby/pry-byebug
	dev-ruby/aws-sdk )"
