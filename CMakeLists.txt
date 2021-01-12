cmake_minimum_required(VERSION 3.5)

project(drake_vendor)

find_package(ament_cmake_core REQUIRED)

# If the user provides hints, follow them
if (DEFINED ENV{DRAKE_INSTALL_PREFIX})
  set(drake_DIR "$ENV{DRAKE_INSTALL_PREFIX}")
  message(STATUS "Looking for drake at ${drake_DIR} [user-provided-hint]")
  find_package(drake QUIET PATHS ${drake_DIR})
endif()

# Default lookup paths
if (NOT drake_FOUND)
  message(STATUS "Looking for drake on default lookup paths")
  find_package(drake QUIET)
endif()

# Fallback, convenience check for a commonly installed path
if (NOT drake_FOUND)
  set(drake_DIR "/opt/drake")
  message(STATUS "Looking for drake at ${drake_DIR} [fallback]")
  find_package(drake QUIET PATHS ${drake_DIR})
endif()

# Hard fail if not found anywhere
if (NOT drake_FOUND)
  message(FATAL_ERROR "\
=====================================================================\n\
No drake installation was found.\n\
-Ddrake_DIR= can be used to pass a path to an existing drake installation.\n\
Check http://drake.mit.edu/installation.html for further reference.\n\
=====================================================================\n\
 ")
endif()

# Compute drake root knowing that ${drake_DIR} amounts to '${drake_ROOT}/lib/cmake/drake'
# TODO: use cmake_path() in CMake 3.20, it will resolve .. components.
set(drake_ROOT "${drake_DIR}/../../.." )

file(READ "${drake_ROOT}/share/doc/drake/VERSION.TXT" drake_VERSION)
string(REPLACE " " ";" drake_VERSION_LIST ${drake_VERSION})
list(GET drake_VERSION_LIST 0 drake_RELEASE_DATE)
list(GET drake_VERSION_LIST 1 drake_RELEASE_COMMIT)

file(READ "${PROJECT_SOURCE_DIR}/DRAKE_VERSION.txt" drake_EXPECTED_VERSION)
string(REPLACE " " ";" drake_EXPECTED_VERSION_LIST ${drake_EXPECTED_VERSION})
list(GET drake_EXPECTED_VERSION_LIST 0 drake_EXPECTED_RELEASE_DATE)

if("${drake_RELEASE_DATE}" LESS "${drake_EXPECTED_RELEASE_DATE}")
  message(FATAL_ERROR "\
=====================================================================\n\
Found a drake installation but it is too old.\n\
Check http://drake.mit.edu/installation.html to update it.\n\
=====================================================================\
")
endif()

message(STATUS "Drake installation found at: ${drake_DIR}")

if("${drake_RELEASE_DATE}" GREATER "${drake_EXPECTED_RELEASE_DATE}")
  message(WARNING "\
=====================================================================\n\
Drake version found is newer than expected, proceed at your own risk.\n\
Check TRI's dsim index repository for reference on supported versions.\n\
=====================================================================\
")
endif()

message(STATUS "Drake Root...................${drake_ROOT}")
message(STATUS "Drake Release Date...........${drake_RELEASE_DATE}")
message(STATUS "Drake Release Commmit........${drake_RELEASE_COMMIT}")

ament_environment_hooks(cmake/drake-package_hook.sh.in)

install(
  PROGRAMS scripts/which_drake.sh
  DESTINATION bin
  RENAME which-drake
)

install(
  PROGRAMS prereqs
  DESTINATION share
)

install(
  FILES DRAKE_VERSION.txt
  DESTINATION share
)

install(
  DIRECTORY etc
  DESTINATION share
)

ament_package(CONFIG_EXTRAS cmake/drake-extras.cmake.in)
