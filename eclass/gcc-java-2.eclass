# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Header: $

ECLASS=gcc-java-2

TOOLCHAIN_PREFIX="/usr/lib/${P}"

inherit check-reqs toolchain

unset E_IUSE
IUSE="debug n32 n64 nls nogtk static vanilla"

if [ "${GCC_BRANCH_VER}" == "4.1" ] ; then
	IUSE="${IUSE} cairo"
elif [ "${GCC_BRANCH_VER}" == "4.2" ] ; then
	IUSE="${IUSE} gconf nsplugin"
fi

gcj_pkg_setup() {
	if is_crosscompile; then
		eerror "cross-compile unsupported!"
		die
	fi

	if use nogtk ; then
		ewarn "You have set 'nogtk' useflag!"
		ewarn "lib(gc)jawt.so won't be built that is required by some applications!"
		ewarn "(i.e., eclipse/SWT or openoffice)"
		ewarn
		ewarn "Do NOT report issues that belong anyhow to *jawt*!"
		elog
	fi

	ewarn "If possible we build dev-java/gcj with sse2 instructions"
	ewarn "to AVOID the numerical instability problems of 387 code."
	ewarn
	ewarn "See:"
	ewarn "	http://gcc.gnu.org/bugzilla/show_bug.cgi?id=28096"
	ewarn "	http://gcc.gnu.org/ml/java/2006-08/msg00102.html"
	elog

	BUILD_WITH_SSE2=""
	if $(cat /proc/cpuinfo | grep -q sse2) ; then
		einfo "Found sse2 support!"
		elog

		BUILD_WITH_SSE2="TRUE"
	fi
	export BUILD_WITH_SSE2

	CHECKREQS_MEMORY="768"
	check_reqs

	if use debug ; then
		export CFLAGS="${CFLAGS} -g"
		export CXXFLAGS="${CXXFLAGS} -g"
	fi

	unset GCC_SPECS
}

gcj_src_unpack() {
	local release_version="Gentoo ${PVR}"

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

	fix_files=""
	for x in contrib/test_summary libstdc++-v3/scripts/check_survey.in ; do
		[[ -e ${x} ]] && fix_files="${fix_files} ${x}"
	done
	ht_fix_file ${fix_files} */configure *.sh */Makefile.in

	version_string="${version_string} (${release_version})"
	einfo "patching gcc version: ${version_string}"
	gcc_version_patch "${version_string}"

	# Misdesign in libstdc++ (Redhat)
	if [[ ${GCCMAJOR} -ge 3 ]] && [[ -e ${S}/libstdc++-v3/config/cpu/i486/atomicity.h ]] ; then
		cp -pPR "${S}"/libstdc++-v3/config/cpu/i{4,3}86/atomicity.h
	fi

	# Fixup libtool to correctly generate .la files with portage
	cd "${S}"
	elibtoolize --portage --shallow --no-uclibc

	gnuconfig_update

	# update configure files
	einfo "Fixing misc issues in configure files"
	for f in $(grep -l 'autoconf version 2.13' $(find "${S}" -name configure)) ; do
		ebegin "  Updating ${f/${S}\/}"
		patch "${f}" "${GCC_FILESDIR}"/gcc-configure-LANG.patch >& "${T}"/configure-patch.log \
			|| die "Please file a bug about this"
		eend $?
	done

	./contrib/gcc_update --touch &> /dev/null
}

gcj_do_configure() {
	local confgcc

	# global configure defaults from toolchain.eclass
	confgcc="--with-system-zlib \
			--disable-checking \
			--disable-werror \
			--disable-libunwind-exceptions"

	[[ ${CTARGET} == *-softfloat-* ]] && confgcc="${confgcc} --with-float=soft"

	# Native Language Support
	if use nls ; then
		confgcc="${confgcc} --enable-nls --without-included-gettext"
	else
		confgcc="${confgcc} --disable-nls"
	fi

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
			[[ ${GCC_PV:0:1} == "3" ]] && \
			confgcc="${confgcc} --enable-sjlj-exceptions"
		;;
	esac

	confgcc="${confgcc} --enable-shared --enable-threads=posix"

	# __cxa_atexit is "essential for fully standards-compliant handling of
	# destructors", but apparently requires glibc.
	# --enable-sjlj-exceptions : currently the unwind stuff seems to work
	# for statically linked apps but not dynamic
	# so use setjmp/longjmp exceptions by default
	if is_uclibc ; then
		confgcc="${confgcc} --disable-__cxa_atexit --enable-target-optspace"
	else
		confgcc="${confgcc} --enable-__cxa_atexit"
	fi
	[[ ${CTARGET} == *-gnu* ]] && confgcc="${confgcc} --enable-clocale=gnu"
	[[ ${CTARGET} == *-uclibc* ]] && confgcc="${confgcc} --enable-clocale=uclibc"

	# GNU Classpath config
	confgcc="${confgcc} $(use_enable !nogtk java-awt gtk)"
	if [ "${GCC_BRANCH_VER}" == "4.1" ] ; then
		confgcc="${confgcc} $(use_enable cairo gtk-cairo)"
	elif [ "${GCC_BRANCH_VER}" == "4.2" ] ; then
		confgcc="${confgcc} $(use_enable nsplugin plugin) \
			$(use_enable gconf gconf-peer) \
			--with-java-home=${PREFIX}/jre"
	fi

	# our build specific configuration
	confgcc="--prefix=${PREFIX} \
		--libdir=${PREFIX}/$(get_libdir) \
		--libexecdir=${PREFIX}/$(get_libdir) \
		--with-gxx-include-dir=${PREFIX}/include/c++ \
		--enable-languages=c,c++,java \
		--enable-ssp \
		--enable-libstdcxx-allocator=new \
		$(use_enable static) \
		--disable-altivec \
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

	# and now to do the actual configuration
	addwrite /dev/zero
	"${S}"/configure ${confgcc} $@ ${EXTRA_ECONF} \
		|| die "failed to run configure"
}

gcj_src_compile() {
	gcc_do_filter_flags

	# Use scalar floating point instructions present in the SSE instruction set.
	#
	# The resulting code should be considerably faster in the majority of cases
	# and avoid the numerical instability problems of 387 code, but may break
	# some existing code that expects temporaries to be 80bit.
	#
	# http://gcc.gnu.org/bugzilla/show_bug.cgi?id=28096
	# http://gcc.gnu.org/ml/java/2006-08/msg00102.html
	if [ "${BUILD_WITH_SSE2}" == "TRUE" ] ; then
		append-flags -msse2 -mfpmath=sse
	fi

	# Build in a separate build tree
	mkdir -p ${WORKDIR}/build
	pushd ${WORKDIR}/build >/dev/null

	gcj_do_configure

	if [[ $(tc-arch) == "x86" || $(tc-arch) == "amd64" || $(tc-arch) == "ppc64" ]] ; then
		GCC_MAKE_TARGET=profiledbootstrap
	else
		GCC_MAKE_TARGET=bootstrap-lean
	fi

	# the gcc docs state that parallel make isnt supported for the
	# profiledbootstrap target, as collisions in profile collecting may occur.
	[[ ${GCC_MAKE_TARGET} == "profiledbootstrap" ]] && export MAKEOPTS="${MAKEOPTS} -j1"

	touch ${S}/gcc/c-gperf.h

	emake \
		BOOT_CFLAGS="$(get_abi_CFLAGS) ${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		LIBPATH="${PREFIX}/$(get_libdir)" \
		STAGE1_CFLAGS="-O" \
		${GCC_MAKE_TARGET} \
		|| die "emake failed with ${GCC_MAKE_TARGET}"

	popd >/dev/null
}

do_cleanup() {
	MY_CHOST="${CHOST}"
	# broken config.sub, config.guess?!
	if use amd64 ; then
		MY_CHOST="${CHOST/pc/unknown}"
	fi

	# delete binaries
	rm ${D}${PREFIX}/bin/{addr2name.awk,c++,cpp,g++,gcc*,gcov,${MY_CHOST}-*}

	# copy headers
	cp -a ${D}${PREFIX}/$(get_libdir)/gcc/${MY_CHOST}/${PV/_/-}/include/{j*,gcj/} \
		${D}${PREFIX}/include/
	cp -a ${D}${PREFIX}/$(get_libdir)/gcc/${MY_CHOST}/${PV/_/-}/include/gcj/* \
		${D}${PREFIX}/include/c++/gcj/

	if [ "${GCC_BRANCH_VER}" == "4.2" ] ; then
		# move libraries
		for f in ${D}${PREFIX}/$(get_libdir)/${P/_/-}/*.la; do
			sed -e "s:/${P/_/-}::g" -i $f
		done
		mv ${D}${PREFIX}/$(get_libdir)/${P/_/-}/lib* ${D}${PREFIX}/$(get_libdir)/
		rm -fr ${D}${PREFIX}/$(get_libdir)/${P/_/-}/
	fi

	# multilib
	[ -d ${D}${PREFIX}/lib64 ] && \
		dosym ${PREFIX}/lib64 ${PREFIX}/lib
}

gcj_src_install() {
	einfo "Installing GCJ ..."
	pushd ${WORKDIR}/build >/dev/null

	make DESTDIR="${D}" install || die "install failed!"

	# Punt some tools which are really only useful while building gcc
	#rm -r "${D}${LIBEXECPATH}"/install-tools
	# This one comes with binutils
	find "${D}" -name libiberty.a -exec rm -f {} \;

	# Some cleanups
	do_cleanup

	if ! use debug ; then
		# Now do the fun stripping stuff
		#env RESTRICT="" STRIP=${CHOST}-strip prepstrip "${D}${BINPATH}" "${D}${LIBEXECPATH}"
		env RESTRICT="" STRIP=${CTARGET}-strip prepstrip "${D}${LIBPATH}"
	fi

	popd >/dev/null
}
