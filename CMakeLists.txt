cmake_minimum_required(VERSION 3.5)

project(drake_vendor)

find_package(ament_cmake_core REQUIRED)

find_package(drake QUIET)

if (NOT drake_FOUND)
  if (NOT drake_DIR)
    set(drake_DIR "/opt/drake")
  endif()

  find_package(drake QUIET PATHS ${drake_DIR})

  if (NOT drake_FOUND)
    message(FATAL_ERROR "\
=====================================================================\n\
No drake installation was found.\n\
-Ddrake_DIR= can be used to pass a path to an existing drake installation.\n\
Check http://drake.mit.edu/installation.html for further reference.\n\
=====================================================================\n\
 ")
  endif()
endif()

# Compute drake root knowing that ${drake_DIR} amounts to '${drake_ROOT}/lib/cmake/drake'
set(drake_ROOT "${drake_DIR}/../../..")

file(READ "${drake_ROOT}/share/doc/drake/VERSION.TXT" drake_VERSION)
string(REPLACE " " ";" drake_VERSION_LIST ${drake_VERSION})
list(GET drake_VERSION_LIST 0 drake_RELEASE_DATE)

file(READ "${PROJECT_SOURCE_DIR}/DRAKE_VERSION.txt" drake_EXPECTED_VERSION)
string(REPLACE " " ";" drake_EXPECTED_VERSION_LIST ${drake_EXPECTED_VERSION})
list(GET drake_EXPECTED_VERSION_LIST 0 drake_EXPECTED_RELEASE_DATE)

if("${drake_RELEASE_DATE}" LESS "${drake_EXPECTED_RELEASE_DATE}")
  message(FATAL_ERROR "\
=====================================================================\n\
Found a drake installation but it is too old.\n\
Check http://drake.mit.edu/installation.html to update it.\n\
=====================================================================\n\
  ")
endif()

message(STATUS "Drake installation found at: ${drake_DIR}")

if("${drake_RELEASE_DATE}" GREATER "${drake_EXPECTED_RELEASE_DATE}")
  message(WARNING "\
=====================================================================\n\
Drake version found is newer than expected, proceed at your own risk.\n\
Check TRI's dsim index repository for reference on supported versions.\n\
=====================================================================\n\
  ")
endif()

ament_environment_hooks(drake-package_hook.sh.in)

install(
  PROGRAMS bin/which_drake.sh
  DESTINATION bin
  RENAME which-drake
)

install(
  PROGRAMS bin/which_drake_tarball.py
  DESTINATION bin
  RENAME which-drake-tarball
)


ament_package(CONFIG_EXTRAS drake-extras.cmake.in)
