project(tclcl)
cmake_minimum_required(VERSION 2.6)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake-modules)
set(TARNAME tclcl)


# program name, version etc

set(PACKAGE_VERSION "1.20")
set(PACKAGE_NAME "TclCL")
set(PACKAGE_TARNAME "${TARNAME}")
set(PACKAGE_STRING "${PACKAGE_NAME} ${PACKAGE_VERSION}")
set(PACKAGE_BUGREPORT "http://sourceforge.net/projects/otcl-tclcl/")

set(LIBTCLCL_SO_VERION_STRING "1.20")
set(LIBTCLCL_SO_CUR_VERSION "1")

set(prefix ${CMAKE_INSTALL_PREFIX})
if(NOT DEFINED BIN_INSTALL_DIR)
    set(BIN_INSTALL_DIR "${CMAKE_INSTALL_PREFIX}/bin")
endif(NOT DEFINED BIN_INSTALL_DIR)
if(NOT DEFINED LIB_INSTALL_DIR)
    set(LIB_INSTALL_DIR "${CMAKE_INSTALL_PREFIX}/lib")
endif(NOT DEFINED LIB_INSTALL_DIR)
if(NOT DEFINED DATA_INSTALL_DIR)
    set(DATA_INSTALL_DIR "${CMAKE_INSTALL_PREFIX}/share")
endif(NOT DEFINED DATA_INSTALL_DIR)
if(NOT DEFINED INCLUDE_INSTALL_DIR)
    set(INCLUDE_INSTALL_DIR "${CMAKE_INSTALL_PREFIX}/include")
endif(NOT DEFINED INCLUDE_INSTALL_DIR)

find_package(PkgConfig REQUIRED)
find_package(TCL REQUIRED)
INCLUDE (CheckFunctionExists)
INCLUDE (CheckIncludeFiles)

#==============================================================================
#### tcl2c++
include_directories(
    ${CMAKE_CURRENT_BINARY_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}
)

set(tcl2cpp_SRC
	tcl2c++.c
)

add_executable(tcl2c++ ${tcl2cpp_SRC})
target_link_libraries(tcl2c++)
install(TARGETS tcl2c++ RUNTIME DESTINATION ${BIN_INSTALL_DIR})

#==============================================================================
### libraries and headers
# libtclcl

exec_program("echo \"puts [info tclversion]\" | tclsh" OUTPUT_VARIABLE TCL_VERSION)

find_path(LIBRARY_TCL init.tcl
	/usr/local/share/tcltk/tcl${TCL_VERSION}
	/usr/share/tcltk/tcl${TCL_VERSION}
	/usr/lib/tcl${TCL_VERSION}
	/usr/lib64/tcl${TCL_VERSION}
)

set(TCL_LIBRARY_FILES 
	${LIBRARY_TCL}/init.tcl 
	${LIBRARY_TCL}/history.tcl 
	${LIBRARY_TCL}/word.tcl 
	${LIBRARY_TCL}/http1.0/http.tcl
)
STRING(REPLACE ";" "	" TCL_LIBRARY_FILES "${TCL_LIBRARY_FILES}")

find_path(LIBRARY_TK tk.tcl
	/usr/local/share/tcltk/tk${TCL_VERSION}
	/usr/share/tcltk/tk${TCL_VERSION}
	/usr/lib/tk${TCL_VERSION}
	/usr/lib64/tk${TCL_VERSION}
)

set(TK_LIBRARY_FILES 
	${LIBRARY_TK}/tk.tcl 
	${LIBRARY_TK}/clrpick.tcl 
	${LIBRARY_TK}/comdlg.tcl 
	${LIBRARY_TK}/button.tcl 
	${LIBRARY_TK}/dialog.tcl 
	${LIBRARY_TK}/entry.tcl 
	${LIBRARY_TK}/focus.tcl 
	${LIBRARY_TK}/listbox.tcl 
	${LIBRARY_TK}/menu.tcl 
	${LIBRARY_TK}/palette.tcl 
	${LIBRARY_TK}/scale.tcl 
	${LIBRARY_TK}/tearoff.tcl 
	${LIBRARY_TK}/text.tcl 
	${LIBRARY_TK}/tkfbox.tcl 
	${LIBRARY_TK}/msgbox.tcl
)
STRING(REPLACE ";" "	" TK_LIBRARY_FILES "${TK_LIBRARY_FILES}")

set(OBJECT_FILES
	${CMAKE_CURRENT_SOURCE_DIR}/tcl-object.tcl
	${CMAKE_CURRENT_SOURCE_DIR}/tcl-import.tcl
	${CMAKE_CURRENT_SOURCE_DIR}/tcl-http.tcl
)
STRING(REPLACE ";" "	" OBJECT_FILES "${OBJECT_FILES}")

set(CONSOLE_FILES ${LIBRARY_TK}/console.tcl)

add_custom_command(OUTPUT embedded-tcl.cc embedded-tk.cc embedded-tclobj.cc
	COMMAND tcl2c++ et_tcl ${TCL_LIBRARY_FILES} > embedded-tcl.cc
	COMMAND sed -i -e 's/package require -exact T/package require T/g' embedded-tcl.cc
	COMMAND tcl2c++ et_tk ${TK_LIBRARY_FILES} > embedded-tk.cc
	COMMAND sed -i -e 's/package require -exact T/package require T/g' embedded-tk.cc
	COMMAND tcl2c++ et_tclobject ${OBJECT_FILES} > embedded-tclobj.cc
	COMMAND tcl2c++ et_console ${CONSOLE_FILES} > embedded-console.cc
)

pkg_check_modules(OTCL REQUIRED otcl)
CHECK_FUNCTION_EXISTS(snprintf HAVE_SNPRINTF)
CHECK_INCLUDE_FILES(stdlib.h STDC_HEADERS)

configure_file(config-tclcl.h.cmake ${CMAKE_CURRENT_BINARY_DIR}/config.h)

include_directories(
    ${CMAKE_CURRENT_BINARY_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${TCL_INCLUDE_PATH}
    ${TK_INCLUDE_PATH}
    ${OTCL_INCLUDE_DIRS}
)

set(libtclcl_SRC
    Tcl.cc
    Tcl2.cc
    idlecallback.cc
    iohandler.cc
    timer.cc
    rate-variable.cc
    tracedvar.cc
    embedded-tcl.cc
    embedded-tk.cc
    embedded-tclobj.cc
)

##### shared
add_library(tclcl SHARED ${libtclcl_SRC})
target_link_libraries(tclcl ${TCL_LIBRARY} ${TK_LIBRARY})
set_target_properties(tclcl PROPERTIES
    VERSION ${LIBTCLCL_SO_VERION_STRING}
    SOVERSION ${LIBTCLCL_SO_CUR_VERSION}
)
##### static
add_library(tclcl-static STATIC ${libtclcl_SRC})
set_target_properties(tclcl-static PROPERTIES OUTPUT_NAME "tclcl")
set_target_properties(tclcl-static PROPERTIES PREFIX "lib")
##### install libraries
install(TARGETS tclcl tclcl-static
	LIBRARY DESTINATION ${LIB_INSTALL_DIR}
	ARCHIVE DESTINATION ${LIB_INSTALL_DIR})

##### install header
file(GLOB tclcl_INCLUDES "*.h")
install(FILES ${tclcl_INCLUDES} DESTINATION ${INCLUDE_INSTALL_DIR}/tclcl COMPONENT Devel)

##### generate ans install pkg-config file.
configure_file(./tclcl.pc.cmake ${CMAKE_CURRENT_BINARY_DIR}/tclcl.pc)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/tclcl.pc DESTINATION ${LIB_INSTALL_DIR}/pkgconfig)
