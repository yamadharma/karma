inherit eutils

ECLASS=patch
INHERITED="$INHERITED $ECLASS"

DESCRIPTION="Base class for applying patches."

patch_base=${FILESDIR}/patch
addsrc_base=${FILESDIR}/addsrc

# {{{ Patch applay

patch_dir ()
{
    local dir=$1
    
    local i=""
    local patch_from_file=""
    
    EPATCH_SUFFIX="patch.bz2"
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
        
    for i in ${IUSE} ${ARCH}
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

patch_apply_patch ()
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

# }}}
# {{{ Additional files for src

# arg1: target directory
# arg2: files to unpack
patch_unpack () 
{
    local UNPACK_DST=$1
    local UNPACK_FILES=$2
    
    local x
    local y
    local myfail
    local tarvars

    if [ "$USERLAND" == "BSD" ] 
	then
	tarvars=""
    else
	tarvars="--no-same-owner"	
    fi	

    cd ${UNPACK_DST}
    
    for x in "${UNPACK_FILES}" 
      do
      myfail="failure unpacking ${x}"
      echo ">>> Unpacking ${x} to $(pwd)"
      y="$(echo $x | sed 's:.*\.\(tar\)\.[a-zA-Z0-9]*:\1:')"
      
      case "${x##*.}" in
	  tar) 
	      tar ${tarvars} -xf ${x} || die "$myfail"
	      ;;
	  tgz) 
	      tar ${tarvars} -xzf ${x} || die "$myfail"
	      ;;
	  tbz2) 
	      bzip2 -dc ${x} | tar ${tarvars} -xf - || die "$myfail"
	      ;;
	  ZIP|zip) 
	      unzip -qo ${x} || die "$myfail"
	      ;;
	  gz|Z|z) 
	      if [ "${y}" == "tar" ] 
		  then
		  tar ${tarvars} -xzf $${x} || die "$myfail"
	      else
		  gzip -dc ${x} > ${x%.*} || die "$myfail"
	      fi
	      ;;
	  bz2) 
	      if [ "${y}" == "tar" ] 
		  then
		  bzip2 -dc ${x} | tar ${tarvars} -xf - || die "$myfail"
	      else
		  bzip2 -dc ${x} > ${x%.*} || die "$myfail"
	      fi
	      ;;
	  *)
	      echo "unpack ${x}: file format not recognized. Ignoring."
	      ;;
      esac
    done
}

# arg1: files to unpack
patch_addsrc_unpack () 
{
    local UNPACK_FILES=$1
    
    patch_unpack ${S} ${UNPACK_FILES}
}

# arg1: dir
patch_addsrc_dir ()
{
    local dir=$1
    
    local i=""
    local addsrc_from_file=""
    
    ADDSRC_SINGLE_MSG=""    
    ADDSRC_SUFFIX="bz2"

    cd ${S}    
    
    for i in ${dir}/*.${ADDSRC_SUFFIX}
      do
      if [ -f ${i}.desc ]
	  then
	  ADDSRC_SINGLE_MSG=`cat ${i}.desc`
      else
	  ADDSRC_SINGLE_MSG=""
      fi
      if [ -f ${i} ]
	  then
	  patch_addsrc_unpack ${i}
      fi
    done
    
    for i in ${IUSE} ${ARCH}
      do
      if ( use ${i} )
	  then
	  if [ -d "${dir}/${i}" ]
	      then
	      patch_addsrc_dir "${dir}/${i}"
	  fi
      else
	  if [ -d "${dir}/no_${i}" ]
	      then
	      patch_addsrc_dir "${dir}/no_${i}"
	  fi
      fi
    done
    
    ADDSRC_SINGLE_MSG=""
}


patch_apply_addsrc ()
{
    if [ -z "${PR}" ]
	then
	my_rev=r0
    else
	my_rev=${PR}
    fi
    
    if [ -d ${addsrc_base}/version ]
	then
	cd ${addsrc_base}/version
	if [ -d ${PV}-${my_rev} ]
	    then
	    patch_addsrc_dir ${addsrc_base}/version/${PV}-${my_rev}
	elif [ -d ${PV} ]
	    then
	    patch_addsrc_dir ${addsrc_base}/version/${PV}
	fi
    fi
}

# }}}
patch_src_unpack () 
{
    unpack ${A}
    patch_apply_patch
    patch_apply_addsrc    

    if [ -n "${patch_OPTIONS}" ]
	then
	for i in ${patch_OPTIONS}
	  do
	  case "$i" in
	      autoconf)
		  cd ${S}
		    autoconf
		  ;;
	      autogen)
		  cd ${S}
		    libtoolize --copy --force --automake
		    aclocal
		    autoheader
		    automake --add-missing --gnu --include-deps
		    autoconf
		  ;;
	      cleancvs)
		  cd ${S}
		  find . -name CVS -exec rm -rf {} \; 2> /dev/null
		  find . -name .cvsignore -exec rm {} \; 2> /dev/null
		  ;;
	      *)
		  ;;
	  esac
	done
    fi	
}


EXPORT_FUNCTIONS src_unpack


# Local Variables:
# mode: sh
# End:
