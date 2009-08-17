# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="CacheFiles is a caching backend that's meant to use as a cache a directory on an already mounted filesystem of a local type (such as Ext3)."
HOMEPAGE="http://people.redhat.com/~dhowells/fscache/"
SRC_URI="http://people.redhat.com/~dhowells/fscache/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

src_install() {
	emake install DESTDIR="${D}" || die "install failed"
	dodoc README howto.txt move-cache.txt
	newconfd ${FILESDIR}/cachefilesd.conf cachefilesd
	newinitd ${FILESDIR}/cachefilesd.init cachefilesd
}

pkg_postinst() {
	[[ -d /var/fscache ]] && return
	elog "Before CacheFiles can be used, a directory for local storage"
	elog "must be created.  The default configuration of /etc/cachefilesd.conf"
	elog "uses /var/fscache.  The filesystem mounted there must support"
	elog "extended attributes (mount -o user_xattr)."
	elog ""
	elog "Once that is taken care of, start the daemon, add -o ...,fsc"
	elog "to the mount options of your network mounts, and let it fly!"
}
