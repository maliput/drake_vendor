cmake_minimum_required(VERSION 3.5)

project(drake_vendor)

find_package(ament_cmake_core REQUIRED)

# If the user provides hints, follow them
#if (DEFINED ENV{DRAKE_INSTALL_PREFIX})
#  set(drake_DIR "$ENV{DRAKE_INSTALL_PREFIX}")
#  message(STATUS "Looking for drake at ${drake_DIR} [user-provided-hint]")
#  find_package(drake QUIET PATHS ${drake_DIR})
#endif()

# Default lookup paths
#if (NOT drake_FOUND)
#  message(STATUS "Looking for drake on default lookup paths")
#  find_package(drake QUIET)
#endif()

# Fallback, convenience check for a commonly installed path
#if (NOT drake_FOUND)
#  set(drake_DIR "/opt/drake")
#  message(STATUS "Looking for drake at ${drake_DIR} [fallback]")
#  find_package(drake QUIET PATHS ${drake_DIR})
#endif()

# Hard fail if not found anywhere
#if (NOT drake_FOUND)
#  message(FATAL_ERROR 
#    " =====================================================================\n"
#    " No drake installation found.\n \n"
#    " Use -Ddrake_DIR= to point to an existing drake installation.\n"
#    " Use the drake-installer utility to install the required version.\n"
#    " See also http://drake.mit.edu/installation.html.\n"
#    " =====================================================================\n"
#  )
#endif()

# Compute drake root knowing that ${drake_DIR} amounts to '${drake_ROOT}/lib/cmake/drake'
# TODO: use cmake_path() in CMake 3.20, it will resolve .. components.
#set(drake_ROOT "${drake_DIR}/../../.." )
#
#file(READ "${drake_ROOT}/share/doc/drake/VERSION.TXT" drake_VERSION)
#string(REPLACE " " ";" drake_VERSION_LIST ${drake_VERSION})
#list(GET drake_VERSION_LIST 0 drake_RELEASE_DATE)
#list(GET drake_VERSION_LIST 1 drake_RELEASE_COMMIT)
#
#file(READ "${PROJECT_SOURCE_DIR}/VERSION.TXT" drake_EXPECTED_VERSION)
#string(REPLACE " " ";" drake_EXPECTED_VERSION_LIST ${drake_EXPECTED_VERSION})
#list(GET drake_EXPECTED_VERSION_LIST 0 drake_EXPECTED_RELEASE_DATE)
#
#if("${drake_RELEASE_DATE}" LESS "${drake_EXPECTED_RELEASE_DATE}")
#  message(FATAL_ERROR
#    " =====================================================================\n"
#    " Found a drake installation but it is too old.\n"
#    " Use the drake-installer utility to upgrade to the required version.\n"
#    " =====================================================================\n"
#  )
#endif()

#message(STATUS "Drake installation found at: ${drake_DIR}")

#if("${drake_RELEASE_DATE}" GREATER "${drake_EXPECTED_RELEASE_DATE}")
#  message(WARNING
#    " =====================================================================\n"
#    " The installed version of drake is newer than expected,\n"
#    " proceed at your own risk.\n"
#    " ====================================================================="
#  )
#endif()
#
#message(STATUS "Drake Root...................${drake_ROOT}")
#message(STATUS "Drake Release Date...........${drake_RELEASE_DATE}")
#message(STATUS "Drake Release Commmit........${drake_RELEASE_COMMIT}")

################################################################################
# Configuration
################################################################################

ament_package_xml()
string(REPLACE "." ";" SEMANTIC_VERSION ${${PROJECT_NAME}_VERSION})
list(GET SEMANTIC_VERSION 0 MAJOR_VERSION)
list(GET SEMANTIC_VERSION 1 MINOR_VERSION)
list(GET SEMANTIC_VERSION 2 PATCH_VERSION)
string(LENGTH ${PATCH_VERSION} PATCH_LENGTH)
if(${PATCH_LENGTH} STREQUAL "8")
  set(VERSION ${PATCH_VERSION})
else()
  set(VERSION ${${PROJECT_NAME}_VERSION})
endif()
if (DEFINED ENV{DRAKE_INSTALL_PREFIX})
  set(drake_DIR "$ENV{DRAKE_INSTALL_PREFIX}")
else()
  set(drake_DIR "/opt/drake/${VERSION}")
endif()
set(drake_VERSION ${${PROJECT_NAME}_VERSION})

message(STATUS "Drake install directory.....${drake_DIR}")

################################################################################
# Installation
################################################################################

install(
  PROGRAMS
    drake-installer
    drake-version
  DESTINATION bin
)

install(
  PROGRAMS prereqs
  DESTINATION share
)

install(
  FILES VERSION.TXT
  DESTINATION share
)

ament_environment_hooks(cmake/drake-package_hook.sh.in)
ament_package(CONFIG_EXTRAS cmake/drake-extras.cmake.in)
