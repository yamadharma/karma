inherit multilib toolchain-funcs

IUSE="doc debug combine non-fhs dynamic static"

DEPEND="${DEPEND}
        >=sys-devel/icemake-9
        doc? ( app-doc/doxygen )"

ICEMAKE_TARGETS=""
ICEMAKE_PREFIX="/usr"
ICEMAKE_ALTERNATE_FHS=""

EXPORT_FUNCTIONS src_compile src_test src_install

icemake_flags() {
	local icemake_params=""

	if use debug; then
		icemake_params="${icemake_params} -D"
	fi

	if use combine; then
		icemake_params="${icemake_params} -c"
	fi

	if use doc; then
		icemake_params="${icemake_params} -x"
	fi

	if use dynamic; then
		icemake_params="${icemake_params} -R"
	fi

	if use static; then
		icemake_params="${icemake_params} -o"
	fi

	echo ${icemake_params}
}

icemake_dl_path() {
	local flags="."

	for i in build/*/*; do
		flags="${flags}:${i}"
	done

	echo ${flags}
}

icemake_src_compile() {
	if use non-fhs; then
		ice ${ICEMAKE_TARGETS} $(icemake_flags)\
			-Ld "${D}/"||die
	else
		ice ${ICEMAKE_TARGETS} $(icemake_flags)\
			-Ld "${D}${ICEMAKE_PREFIX}"||die
	fi
}

icemake_src_test() {
	if use non-fhs; then
		LD_LIBRARY_PATH="$(icemake_dl_path)" ice ${ICEMAKE_TARGETS}\
			$(icemake_flags)\
			-Ldr "${D}/"||ewarn "WARNING: $? test case(s) failed"
	else
		LD_LIBRARY_PATH="$(icemake_dl_path)" ice ${ICEMAKE_TARGETS}\
			$(icemake_flags)\
			-Ldr "${D}${ICEMAKE_PREFIX}"||ewarn "WARNING: $? test case(s) failed."
	fi
}

icemake_src_install() {
	if use non-fhs; then
		ice ${ICEMAKE_TARGETS} $(icemake_flags)\
			-Ldis "${D}/"||die
	else
		if [ -z "${ICEMAKE_ALTERNATE_FHS}" ]; then
			ice ${ICEMAKE_TARGETS} $(icemake_flags)\
				-Ldifl "${D}${ICEMAKE_PREFIX}" $(get_libdir)||die
		else
			ice ${ICEMAKE_TARGETS} $(icemake_flags)\
				-Ldibl "${D}${ICEMAKE_PREFIX}" ${ICEMAKE_ALTERNATE_FHS}\
					$(get_libdir)||die
		fi
	fi

	for i in lib lib32 lib64; do
		if [ -d ${D}/${i} ]; then
			mkdir -p ${D}/usr/${i}
			mv ${D}/${i}/*.a ${D}/usr/${i}

			if [ -d ${D}/${i}/pkgconfig ]; then
				mv ${D}/${i}/pkgconfig ${D}/usr/${i}
			fi

			for j in ${D}/${i}/*.so; do
				if [ -h ${j} ]; then
					gen_usr_ldscript ${j##*/}
				fi
			done
		fi
	done

	for i in include share; do
		if [ -d ${D}/$i ]; then
			if [ ! -d "${D}/usr" ]; then
				mkdir -p ${D}/usr;
			fi

			mv ${D}/$i ${D}/usr/$i
		fi
	done

	if [ -d documentation/man ]; then
		doman documentation/man/*
	fi

	if use doc; then
		for i in documentation/doxygen/man/*/*; do
			doman ${i}
		done
	fi

	dodoc AUTHORS COPYING CREDITS README
}

