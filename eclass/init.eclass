ECLASS=init
INHERITED="$INHERITED $ECLASS"

DESCRIPTION="Base class for applying patches."

IUSE="daemontools"

DEPENDS="daemontools?	sys-apps/daemontools"

init_base=${FILESDIR}/init

gentoo-sysv_base=${init_base}/gentoo-sysv
daemontools_base=${init_base}/daemontools

patch_dir ()
{
    local dir=$1
    
    local i=""
    local patch_from_file=""
    
    EPATCH_SINGLE_MSG=""    

    cd ${S}    

    for i in ${dir}/*.${EPATCH_SUFFIX}
      do
      if [ -f ${i}.desc ]
	  then
	  EPATCH_SINGLE_MSG=`cat ${i}.desc`
      else
	  EPATCH_SINGLE_MSG=""
      fi
      if [ -f ${i} ]
	  then
	  epatch ${i}
      fi
    done
    
    for i in ${dir}/*.patchfile
      do
      if [ -f ${i}.desc ]
	  then
	  EPATCH_SINGLE_MSG=`cat ${i}.desc`
      else
	  EPATCH_SINGLE_MSG=""
      fi
      if [ -f ${i} ]
	  then
	  echo "echo " `cat ${i}`> ${T}/patch_from_file
	  patch_from_file=`source ${T}/patch_from_file`
	  epatch ${patch_from_file}
	  rm -f ${T}/patch_from_file
      fi
    done
        
    for i in ${IUSE}
      do
      if ( use ${i} )
	  then
	  if [ -d "${dir}/${i}" ]
	      then
	      patch_dir "${dir}/${i}"
	  fi
      else
	  if [ -d "${dir}/no_${i}" ]
	      then
	      patch_dir "${dir}/no_${i}"
	  fi
      fi
    done
    
    EPATCH_SINGLE_MSG=""
}

apply_patch ()
{
    if [ -z "${PR}" ]
	then
	my_rev=r0
    else
	my_rev=${PR}
    fi
    
    if [ -d ${patch_base}/version ]
	then
	cd ${patch_base}/version
	if [ -d ${PV}-${my_rev} ]
	    then
	    patch_dir ${patch_base}/version/${PV}-${my_rev}
	elif [ -d ${PV} ]
	    then
	    patch_dir ${patch_base}/version/${PV}
	fi
    fi
}

init_install () 
{
    unpack ${A}
}


EXPORT_FUNCTIONS init_install


# Local Variables:
# mode: sh
# End:
