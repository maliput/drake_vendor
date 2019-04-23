cmake_minimum_required(VERSION 3.5)

project(drake_vendor)

find_package(ament_cmake_core REQUIRED)

if (NOT drake_DIR)
  set(drake_DIR "/opt/drake")
endif()

set(drake_DIR_set "${drake_DIR}")

find_package(drake QUIET PATHS ${drake_DIR})

if (NOT drake_FOUND)
  message(FATAL_ERROR "\
 =====================================================================\n\
 A Drake installation was not found at ${drake_DIR_set}.\n\
 -Ddrake_DIR= can be used to pass a path to an existing drake installation.\n\
 Check http://drake.mit.edu/installation.html for further reference\n\
 =====================================================================\n\
 ")
endif()

message(STATUS "Drake installation found at: ${drake_DIR}")

# Compute drake root knowing that ${drake_DIR} amounts to '${drake_ROOT}/lib/cmake/drake'
set(drake_ROOT "${drake_DIR}/../../..")

ament_environment_hooks(drake-package_hook.sh.in)

ament_package(CONFIG_EXTRAS drake-extras.cmake.in)
