ECLASS=extrafiles
INHERITED="$INHERITED $ECLASS"

DESCRIPTION="Base class for applying patches."

#IUSE="${IUSE}"

IUSE="${IUSE} daemontools"

DEPENDS="daemontools?	sys-apps/daemontools"

#init_base=${FILESDIR}/init
init_base=${FILESDIR}/extra/init

gentoo_sysv_base=${init_base}/gentoo-sysv
daemontools_base=${init_base}/daemontools

#conf_base=${FILESDIR}/conf
#etc_base=${FILESDIR}/etc

conf_base=${FILESDIR}/extra/conf
etc_base=${FILESDIR}/extra/etc

# {{{ majorversion list calculation

v=${PV}
mv=${v%.*}
mv_list=${mv}
while [ "${mv}" != "${v}" ]
  do
  v=${mv}
  mv=${v%.*}
  mv_list="${mv_list} ${mv}"
done

mv_list=${mv_list% *}

# }}}

# arg: $1 = directory
#
extrafiles_copy_init_gentoo_sysv ()
{
    dir=$1
    cd ${dir}
    
    if [ -d init.d ]
	then
	exeinto /etc/init.d
	doexe init.d/*
    fi
    
    if [ -d conf.d ]
	then
	dodir /etc/conf.d
	cp -r conf.d/* ${D}/etc/conf.d
    fi
}

# arg: $1 = directory
#
extrafiles_copy_init_daemontools ()
{
    dir=$1
    cd ${dir}
    
    if [ -d init.d ]
	then
	exeinto /etc/init.d
	doexe init.d/*
    fi
    
    if [ -d conf.d ]
	then
	dodir /etc/conf.d
	cp -r conf.d/* ${D}/etc/conf.d
    fi
}

# arg: $1 = directory
#
extrafiles_copy_etc ()
{
    dir=$1
    cd ${dir}
    
    cp -r * ${D}/etc
}

# arg: $1 = type of init
#
extrafiles_install_init_type () 
{
    init_type=$1
    local init_type_base=""
    local init_type_copy=""

    case "${init_type}" in 
	gentoo-sysv)
	    init_type_base=${gentoo_sysv_base}
	    init_type_copy="gentoo_sysv"
	    ;;
	daemontools)
	    init_type_base=${daemontools_base}
	    init_type_copy="daemontools"
	    ;;
    esac
    
    if [ -z "${PR}" ]
	then
	my_rev=r0
    else
	my_rev=${PR}
    fi
    
    if [ -d ${init_type_base}/version ]
	then
	cd ${init_type_base}/version
	if [ -d ${PV}-${my_rev} ]
	    then
	    extrafiles_copy_init_${init_type_copy} ${init_type_base}/version/${PV}-${my_rev}
	    return 0
	elif [ -d ${PV} ]
	    then
	    extrafiles_copy_init_${init_type_copy} ${init_type_base}/version/${PV}
	    return 0
	fi
    fi
    	
    if [ -d ${init_type_base}/majorversion ]
	then
	cd ${init_type_base}/majorversion
	for majorversion in ${mv_list}
	  do
	  if [ -d ${majorversion} ]
	      then
	      extrafiles_copy_init_${init_type_copy} ${init_type_base}/majorversion/${majorversion}
	      return 0
	  fi
	done
    fi
}

extrafiles_install_init () 
{
    extrafiles_install_init_type gentoo-sysv
    if ( use daemontools )
	then
        extrafiles_install_init_type daemontools
    fi
}


extrafiles_install_etc () 
{
    if [ -z "${PR}" ]
	then
	my_rev=r0
    else
	my_rev=${PR}
    fi
    
    if [ -d ${etc_base}/version ]
	then
	cd ${etc_base}/version
	if [ -d ${PV}-${my_rev} ]
	    then
	    extrafiles_copy_etc ${etc_base}/version/${PV}-${my_rev}
	    return 0
	elif [ -d ${PV} ]
	    then
	    extrafiles_copy_etc ${etc_base}/version/${PV}
	    return 0
	fi
    fi
    
    if [ -d ${etc_base}/majorversion ]
	then
	cd ${etc_base}/majorversion
	for majorversion in ${mv_list}
	  do
	  if [ -d ${majorversion} ]
	      then
	      extrafiles_copy_etc ${etc_base}/majorversion/${majorversion}
	      return 0
	  fi
	done
    fi
}

extrafiles_install () 
{
    extrafiles_install_init
    extrafiles_install_etc
}


# EXPORT_FUNCTIONS install install_init install_etc


# Local Variables:
# mode: sh
# End:
