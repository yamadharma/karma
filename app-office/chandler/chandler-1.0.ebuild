# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# FIXME: Maybe support a USE flag for debug build
# FIXME: Scan for error conditions and implement appropriate dies
# FIXME: Install into a subdirectory of /usr/lib/chandler and support
#        SLOTS to allow multiple parallel installs
# FIXME: Examine user,group,perms of resulting files

inherit eutils versionator

DESCRIPTION="Personal information manager (PIM) desktop application and framework"
HOMEPAGE="http://www.osafoundation.org/"
LICENSE="Apache-2.0"
KEYWORDS="x86 amd64"
IUSE=""
SLOT="0"

#MY_PV=$(replace_all_version_separators '_')
SRC_URI="http://downloads.osafoundation.org/chandler/releases/${PV}/Chandler_src_${PV}.tar.gz"
RESTRICT="nomirror"

# FIXME: Maybe Perl, SDL, libpng.  Probably significant amount of
# other stuff.
# FIXME: Install in a fresh Gentoo install to catch additional dependencies.
# FIXME: Remove conflicit with CVS chandler
#
# Really should depend on gcc with the gcj use flag set, but
# apparently not possible to specify that condition here.
DEPEND=">=x11-libs/gtk+-2
	>=dev-lang/python:2.5
	sys-libs/db:4.6
	dev-libs/icu"
	
RDEPEND="${DEPEND}"

# FIXME: Somehow detect GCJ properly; since built_with_use uses
# best_version, it won't find GCJ in any non-default slots
#pkg_setup() {
#	if [[ ! $(built_with_use gcc gcj) ]] ; then
#		eerror 'Chandler build requires that GCC be built with the "gcj" USE flag'
#		die "exiting because of GCJ dependency"
#	fi
#}

src_compile() {
	# FIXME: Hmmm, how to get the right profile or detect during build
	# time that we're running GCC+GCJ >= 3.4.2.  How to automatically
	# use a slot with GCJ even if default is not gcj enabled?  Using a
	# blank profile just means "current", so it picks up whatever is
	# currently set.
	GCC_PROFILE=
	GCC_LIB=`gcc-config -L ${GCC_PROFILE}`
	GCC_BIN=`gcc-config -B ${GCC_PROFILE}`

	# Need to create a fake GCJ_HOME pointing to Gentoo versions
	mkdir -p gcj-home/bin
	cd gcj-home
	ln -s ${GCC_LIB} lib
	cd bin
	for i in ${GCC_BIN}/*; do
		ln -s ${i} `basename ${i}`
	done
	# Chandler build assumes jar binary is named "jar" so make one available
	ln -s gcj-jar jar

	# Compile Chandler the way it wants to be built.  Force
	# single-threaded make as package won't build in parallel (bug #1853).
	cd ${S}/external || die
	env GCJ_HOME=${S}/gcj-home BUILD_ROOT=${S}/external emake -j1 world
}

src_install() {
	# Remove extraneous CVS directories FIXME: Work with upstream to
	# have distro tarballs not have CVS artifacts in them
	find ${S} -type d -name CVS | xargs -r rm -rf
	find ${S} -type f -name .cvsignore | xargs -r rm

	# FIXME: Maybe use /usr/share/chandler instead
	INST_ROOT=/usr/lib/${PN}/${PV}
	dodir ${INST_ROOT}
	dodir /usr/bin
	# FIXME: Work with upstream to support a "make DESTDIR=${D} install" option
	cp -a ${S}/chandler/* ${D}${INST_ROOT}

	# Create a simple wrapper suitable for placement into /usr/bin
	# FIXME: Switch to installation of /usr/lib/chandler/chandler as
	# /usr/bin/chandler FIXME: Install with ebuild do* function
	# perhaps
	CBIN=${D}/usr/bin/chandler
	cat > ${CBIN} <<EOF
#!/bin/sh

cd ${INST_ROOT}
release/RunChandler $*
EOF
	chmod +x ${CBIN}
#	dosym ${INST_ROOT}/chandler /usr/bin/chandler
}
