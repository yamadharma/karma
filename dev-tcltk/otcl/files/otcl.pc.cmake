prefix=${CMAKE_INSTALL_PREFIX}
exec_prefix=${BIN_INSTALL_DIR}
libdir=${LIB_INSTALL_DIR}
includedir=${INCLUDE_INSTALL_DIR}

Name: otcl
Description: OTcl - MIT Object Tcl
Requires: 
Version: ${PACKAGE_VERSION}
Libs: -L${LIB_INSTALL_DIR} -lotcl -L${TCL_LIBRARY} -ltcl
Cflags: -I${INCLUDE_INSTALL_DIR} -I${TCL_INCLUDE_PATH}
