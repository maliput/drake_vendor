cmake_minimum_required(VERSION 3.5)

################################################################################
# CMake
################################################################################

project(drake_vendor)

################################################################################
# Dependencies
################################################################################

find_package(ament_cmake_core REQUIRED)

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

file(READ "${PROJECT_SOURCE_DIR}/VERSION.TXT" drake_EXPECTED_VERSION)
string(REPLACE " " ";" drake_EXPECTED_VERSION_LIST ${drake_EXPECTED_VERSION})
list(GET drake_EXPECTED_VERSION_LIST 0 drake_EXPECTED_RELEASE_DATE)
list(GET drake_EXPECTED_VERSION_LIST 1 drake_EXPECTED_RELEASE_COMMIT)

################################################################################
# Configuration Reporting
################################################################################

message(STATUS "Drake Install Dir............${drake_DIR}")
message(STATUS "Drake Release Date...........${drake_EXPECTED_RELEASE_DATE}")
message(STATUS "Drake Release Commmit........${drake_EXPECTED_RELEASE_COMMIT}")

################################################################################
# Installation
################################################################################

install(
  PROGRAMS
    drake_installer
    drake_version
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
