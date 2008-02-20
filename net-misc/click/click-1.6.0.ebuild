# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils

DESCRIPTION="The Click Modular Router"
HOMEPAGE="http://read.cs.ucla.edu/click/"
SRC_URI="http://read.cs.ucla.edu/click/click-1.6.0.tar.gz"

IUSE="nsclick wifi ipv6"
#RDEPEND="nsclick? ( >=my/ns-2.3 )"
RDEPEND=""
DEPEND=""

SLOT="0"
LICENSE="MIT"
KEYWORDS="x86 amd64"


src_compile ()
{
	local myconf
	
	myconf="${myconf} $(use_enable nsclick)"
	myconf="${myconf} $(use_enable wifi)"			#include wifi elements and support
	myconf="${myconf} $(use_enable ipv6 ip6)"		#include IPv6 elements (EXPERIMENTAL)

	myconf="${myconf} --enable-all-elements"
  		
		#--enable-all-elements \   #включить все возможные элементы Click
  		#--enable-analysis \   #include elements for network analysis
  		#--enable-etherswitch \   #include Ethernet switch elements (EXPERIMENTAL)
  		#--enable-grid \   #include Grid elements (see FAQ)
  		#--enable-ipsec \   #include IP security elements
  		#--enable-local \   #include local elements
  		#--enable-radio \   #include radio elements (EXPERIMENTAL)
  		#--enable-simple \   #include simple versions of other elements
  		#--enable-test \   #include regression test elements
  		#--enable-dmalloc \   #enable debugging malloc
  		#--enable-intel-cpu     #enable Intel-specific machine instructions
		#--disable-userlevel   \   #отключить драйвера уровня пользователя
		#--disable-linuxmodule \  #не создавать модуль ядра				
		#--disable-app        \   #do not include application-level elements
		#--disable-aqm        \   #do not include active queue management elements
		#--disable-icmp       \   #do not include ICMP elements
		#--disable-ip         \   #do not include IP elements
		#--disable-ethernet   \   #do not include Ethernet elements
		#--disable-standard   \   #do not include standard elements
		#--disable-tcpudp     \   #do not include TCP and UDP elements
		#--disable-int64      \   #disable 64-bit integer support

	econf \
		--disable-linuxmodule \
		${myconf} || die "econf failed"
	make || die "make failed"
}

src_install ()
{
	
	make DESTDIR="${D}" install || die "install failed"	
	#ewarn "Install completed"
}
