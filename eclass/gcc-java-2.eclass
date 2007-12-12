# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Header: $

ECLASS=gcc-java-2

GCC_VAR_TYPE=non-versioned
TOOLCHAIN_PREFIX="/usr/lib/${P}"

inherit check-reqs toolchain java-utils-2

unset E_IUSE
IUSE="altivec debug elibc_FreeBSD gconf n32 n64 nls nogtk nsplugin static vanilla"

gcj_pkg_setup() {
	if is_crosscompile; then
		eerror "cross-compile unsupported!"
		die
	fi

	case $(tc-arch) in
	mips)
		# Must compile for mips64-linux target if we want n32/n64 support
		case "${CTARGET}" in
			mips64*) ;;
			*)
				if use n32 || use n64; then
					eerror "n32/n64 can only be used when target host is mips64*-*-linux-*";
					die "Invalid USE flags for CTARGET ($CTARGET)";
				fi
			;;
		esac

		#cannot have both n32 & n64
		if use n32 && use n64; then
			die "Invalid USE flag combination (n32 & n64)";
		fi
	;;
	esac

	if use nogtk ; then
		ewarn "You have set 'nogtk' useflag!"
		ewarn "lib(gc)jawt.so won't be built that is required by some applications!"
		ewarn "(i.e., eclipse/SWT or openoffice)"
		ewarn
		ewarn "Do NOT report issues that belong anyhow to *jawt*!"
		elog
	fi

	use debug && append-flags -g
	CHECKREQS_MEMORY="768"
	check_reqs

	# we dont want to use the installed compiler's specs to build gcc!
	unset GCC_SPECS
}

gcj_src_unpack() {
	local release_version="Gentoo ${GCC_PVR}"

	gcc_quick_unpack
	exclude_gcc_patches

	cd ${S:=$(gcc_get_s_dir)}

	if ! use vanilla ; then
		if [[ -n ${PATCH_VER} ]] ; then
			guess_patch_type_in_dir "${WORKDIR}"/patch
			EPATCH_MULTI_MSG="Applying Gentoo patches ..." \
			epatch "${WORKDIR}"/patch
		fi
		if [[ -n ${UCLIBC_VER} ]] ; then
			guess_patch_type_in_dir "${WORKDIR}"/uclibc
			EPATCH_MULTI_MSG="Applying uClibc patches ..." \
			epatch "${WORKDIR}"/uclibc
		fi
	fi

	# protoize don't build on FreeBSD, skip it
	if ! is_crosscompile && ! use elibc_FreeBSD ; then
		# enable protoize / unprotoize
		sed -i -e '/^LANGUAGES =/s:$: proto:' "${S}"/gcc/Makefile.in
	fi

	fix_files=""
	for x in contrib/test_summary libstdc++-v3/scripts/check_survey.in ; do
		[[ -e ${x} ]] && fix_files="${fix_files} ${x}"
	done
	ht_fix_file ${fix_files} */configure *.sh */Makefile.in

	version_string=${GCC_CONFIG_VER}
	einfo "patching gcc version: ${version_string} (${release_version})"
	gcc_version_patch "${version_string}" "${release_version}"

	echo ${PV/_/-} > "${S}"/gcc/BASE-VER
	echo "" > "${S}"/gcc/DATESTAMP

	# Misdesign in libstdc++ (Redhat)
	if [[ -e ${S}/libstdc++-v3/config/cpu/i486/atomicity.h ]] ; then
		cp -pPR "${S}"/libstdc++-v3/config/cpu/i{4,3}86/atomicity.h
	fi

	# Fixup libtool to correctly generate .la files with portage
	cd "${S}"
	elibtoolize --portage --shallow --no-uclibc

	gnuconfig_update

	# update configure files
	local f
	einfo "Fixing misc issues in configure files"
	for f in $(grep -l 'autoconf version 2.13' $(find "${S}" -name configure)) ; do
		ebegin "  Updating ${f/${S}\/}"
		patch "${f}" "${GCC_FILESDIR}"/gcc-configure-LANG.patch >& "${T}"/configure-patch.log \
			|| die "Please file a bug about this"
		eend $?
	done

	if [[ ${GCCMAJOR}.${GCCMINOR} == 4.3 ]]; then
		cd ${S}
		epatch ${FILESDIR}/gentoo-multilib-fixincludes.diff
		epatch ${FILESDIR}/gcj-4.3-tools.jar-path.diff
	fi
}

gcj_do_configure() {
	local confgcc

	# global configure defaults from toolchain.eclass
	confgcc="--with-system-zlib \
			--disable-checking \
			--disable-werror \
			--disable-libunwind-exceptions"

	[[ $(tc-arch) != powerpc ]] && confgcc="${confgcc} --enable-secureplt"

	[[ ${CTARGET} == *-softfloat-* ]] && confgcc="${confgcc} --with-float=soft"

	# Native Language Support
	confgcc="${confgcc} `use_enable nls`"
	use nls && confgcc="${confgcc} --without-included-gettext"

	case $(tc-arch) in
		# Add --with-abi flags to set default MIPS ABI
		mips)
		local mips_abi=""
		use n64 && mips_abi="--with-abi=64"
		use n32 && mips_abi="--with-abi=n32"
		[[ -n ${mips_abi} ]] && confgcc="${confgcc} ${mips_abi}"
		;;
		# Enable sjlj exceptions for backward compatibility on hppa
		hppa)
			[[ ${GCC_PV:0:1} == 3 ]] && \
			confgcc="${confgcc} --enable-sjlj-exceptions"
		;;
	esac

	confgcc="${confgcc} --enable-shared --enable-threads=posix"

	[[ ${CTARGET} == *-elf ]] && confgcc="${confgcc} --with-newlib"
	# __cxa_atexit is "essential for fully standards-compliant handling of
	# destructors", but apparently requires glibc.
	# --enable-sjlj-exceptions : currently the unwind stuff seems to work
	# for statically linked apps but not dynamic
	# so use setjmp/longjmp exceptions by default
	if [[ ${CTARGET} == *-uclibc* ]] ; then
		confgcc="${confgcc} --disable-__cxa_atexit --enable-target-optspace"
	elif [[ ${CTARGET} == *-gnu* ]] ; then
		confgcc="${confgcc} --enable-__cxa_atexit"
	fi
	[[ ${CTARGET} == *-gnu* ]] && confgcc="${confgcc} --enable-clocale=gnu"
	[[ ${CTARGET} == *-uclibc* ]] && confgcc="${confgcc} --enable-clocale=uclibc"

	# gnu java / classpath config
	confgcc="${confgcc} --with-java-home=${PREFIX}/jre \
		$(use_enable !nogtk java-awt gtk) \
		$(use_enable nsplugin plugin) \
		$(use_enable gconf gconf-peer)"
	[[ ${GCCMAJOR}.${GCCMINOR} == 4.3 ]] \
		&& confgcc="${confgcc} \
			--with-ecj-jar=$(java-pkg_getjar eclipse-ecj-${ECJ_VER} ecj.jar)"

	# able to build java source?
	[[ ( -x $(which gjavah) ) && ( -x $(which ecj1) ) ]] \
		&& confgcc="${confgcc} --enable-java-maintainer-mode"

	# our build specific configuration
	confgcc="--prefix=${PREFIX} \
		--libdir=${LIBPATH} \
		--libexecdir=${LIBPATH} \
		--with-gxx-include-dir=${INCLUDEPATH}/c++ \
		--enable-languages=c,c++,java \
		--enable-ssp \
		--enable-libstdcxx-allocator=new \
		$(use_enable static) \
		$(use_enable altivec) \
		--disable-gtktest \
		--disable-glibtest \
		--disable-multilib \
		--disable-maintainer-mode \
		--disable-libada \
		--disable-libarttest \
		--disable-libjava-multilib \
		--disable-libmudflap \
		--disable-libssp \
		${confgcc}"

	echo
	einfo "Configuring GCJ with: ${confgcc//--/\n\t--} ${@} ${EXTRA_ECONF}"
	echo

	# Build in a separate build tree
	mkdir -p ${WORKDIR}/build
	pushd ${WORKDIR}/build >/dev/null

	# and now to do the actual configuration
	addwrite /dev/zero
	"${S}"/configure ${confgcc} $@ ${EXTRA_ECONF} \
		|| die "failed to run configure"

	popd >/dev/null
}

gcj_src_compile() {
	gcc_do_filter_flags
	# work around gcc PR33992
	replace-flags -O? -O1
	! is-flagq -O1 && append-flags -O1

	export PATH="${PATH}:${JAVA_HOME}/bin"
	gcj_do_configure
	touch ${S}/gcc/c-gperf.h

	einfo "Compiling ${PN} ..."
	gcc_do_make
}

do_cleanup() {
	MY_CHOST="${CHOST}"
	# broken config.sub, config.guess
	if use amd64 ; then
		MY_CHOST="${CHOST/pc/unknown}"
	fi

	# delete binaries
	rm ${D}${BINPATH}/{addr2name.awk,c++,cpp,g++,gcc*,gcov,${MY_CHOST}-*}

	# copy headers
	cp -a ${D}${LIBPATH}/gcc/${MY_CHOST}/${PV/_/-}/include/{j*,gcj/} \
		${D}${INCLUDEPATH}
	cp -a ${D}${LIBPATH}/gcc/${MY_CHOST}/${PV/_/-}/include/gcj/* \
		${D}${INCLUDEPATH}/c++/gcj/

	# move libraries
	for f in ${D}${LIBPATH}/${PN}*/*.la; do
		sed -e "s:^libdir=.*:libdir=\'${LIBPATH}\':g" -i ${f}
	done
	mv ${D}${LIBPATH}/${PN}*/lib* ${D}${LIBPATH}
	rm -fr ${D}${LIBPATH}/${PN}*/

	[[ -d ${D}${PREFIX}/lib64 ]] \
		&& dosym ${PREFIX}/lib64 ${PREFIX}/lib

	dodir ${PREFIX}/jre/lib
	dosym ${DATAPATH}/java/lib${P/_/-}.jar ${PREFIX}/jre/lib/rt.jar
	dosym ${LIBPATH}/gcc/${MY_CHOST}/${PV/_/-}/ecj1 ${BINPATH}/ecj1
}

gcj_src_install() {
	local x=

	# Do allow symlinks in ${PREFIX}/lib/gcc-lib/${CHOST}/${GCC_CONFIG_VER}/include as
	# this can break the build.
	for x in "${WORKDIR}"/build/gcc/include/* ; do
		[[ -L ${x} ]] && rm -f "${x}"
	done
	# Remove generated headers, as they can cause things to break
	# (ncurses, openssl, etc).
	for x in $(find "${WORKDIR}"/build/gcc/include/ -name '*.h') ; do
		grep -q 'It has been auto-edited by fixincludes from' "${x}" \
			&& rm -f "${x}"
	done

	einfo "Installing GCJ ..."
	cd ${WORKDIR}/build
	S=${WORKDIR}/build \
	make DESTDIR="${D}" install || die "install failed!"

	# Punt some tools which are really only useful while building gcc
	find "${D}" -name install-tools -type d -exec rm -rf "{}" \;
	# This one comes with binutils
	find "${D}" -name libiberty.a -exec rm -f {} \;

	# Some cleanups
	do_cleanup

	if ! use debug ; then
		# Now do the fun stripping stuff
		env RESTRICT="" CHOST=${CHOST} prepstrip "${D}${BINPATH}"
		env RESTRICT="" CHOST=${CTARGET} prepstrip "${D}${LIBPATH}"
	fi

	# prune empty dirs left behind
	find "${D}" -type d | xargs rmdir >& /dev/null

	# use gid of 0 because some stupid ports don't have
	# the group 'root' set to gid 0
	chown -R root:0 "${D}"${LIBPATH}
}
