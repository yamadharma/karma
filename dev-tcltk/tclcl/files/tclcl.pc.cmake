prefix=${CMAKE_INSTALL_PREFIX}
exec_prefix=${BIN_INSTALL_DIR}
libdir=${LIB_INSTALL_DIR}
includedir=${INCLUDE_INSTALL_DIR}/tclcl

Name: tclcl
Description: TclCL - Tcl with classes
Requires: otcl
Version: ${PACKAGE_VERSION}
Libs: -L${LIB_INSTALL_DIR} -ltclcl -L${TCL_LIBRARY} -ltcl -L${TK_LIBRARY} -ltk -L${OTCL_LIBRARY_DIRS} -lotcl
Cflags: -I${INCLUDE_INSTALL_DIR}/tclcl -I${TCL_INCLUDE_PATH} -I${TK_INCLUDE_PATH} -I${OTCL_INCLUDE_DIRS}
