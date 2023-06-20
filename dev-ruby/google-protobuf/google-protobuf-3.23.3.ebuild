# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

RUBY_FAKEGEM_EXTENSIONS=(ext/google/protobuf_c/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR=lib/google

inherit ruby-fakegem

DESCRIPTION="Protocol Buffers are Google's data interchange format"
HOMEPAGE="https://developers.google.com/protocol-buffers"
SRC_URI="https://github.com/protocolbuffers/protobuf/archive/v${PV}/${PV}.tar.gz -> ${P}-ruby.tar.gz"
# For some reason google now bundles everthing together into one release
RUBY_S="protobuf-${PV}/ruby"

LICENSE="BSD"
SLOT="3"
KEYWORDS="~amd64"
IUSE=""

BDEPEND+="test? ( >=dev-libs/protobuf-19.0 )"

all_ruby_prepare() {
	mkdir -p 'ext/google/protobuf_c/third_party/utf8_range'
	cp '../third_party/utf8_range/utf8_range.h' 'ext/google/protobuf_c/third_party/utf8_range'
	cp '../third_party/utf8_range/naive.c' 'ext/google/protobuf_c/third_party/utf8_range'
	cp '../third_party/utf8_range/range2-neon.c' 'ext/google/protobuf_c/third_party/utf8_range'
	cp '../third_party/utf8_range/range2-sse.c' 'ext/google/protobuf_c/third_party/utf8_range'
	cp '../third_party/utf8_range/LICENSE' 'ext/google/protobuf_c/third_party/utf8_range'

	sed -e '/extensiontask/ s:^:#:' \
		-e '/ExtensionTask/,/^  end/ s:^:#:' \
		-e 's/:compile,//' \
		-e '/:test/ s/:build,//' \
		-i Rakefile || die
		#-e 's:../src/protoc:protoc:' \
}

each_ruby_configure() {
    ${RUBY} -Cext/google/protobuf_c extconf.rb || die
}

each_ruby_compile(){
    emake -Cext/google/protobuf_c V=1 || die
	cp 'ext/google/protobuf_c/protobuf_c.so' 'lib/google/protobuf' || die
	# https://github.com/protocolbuffers/protobuf/pull/9219 - TEMP cd *.rb from lib to /usr/lib64/ruby/gems/3.1.0/gems/google-protobuf-3.23.0/lib/google/
}
