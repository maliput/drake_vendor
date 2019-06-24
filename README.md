# drake_vendor

## Overview

`drake_vendor` is an ament cmake shim for `drake`, easing its use in a `colcon` workspace
whether `drake` sources are part of the build or a binary distribution has been installed
on the system.

Upon CMake configuration, an attempt is made to find an existing `drake` installation. If
it's not found, the build will fail. If it's found, its `VERSION.txt` file is matched against
the expected [`DRAKE_VERSION.txt`](DRAKE_VERSION.txt) file. Only exact matches result in silent
success. Older versions will result in an error while newer versions will result in a warning.

In addition to this functionality, a [prerequisites script](prereqs) is available to automate
the installation of binary `drake` nightly distributions. First, an attempt is made to find an
existing `drake` installation at the path specified by the `DRAKE_INSTALL_PREFIX` environment
variable, falling back to `/opt/drake` if the latter is not defined.
If it's found and it's either an exact match with the expected version or a newer one, no
installation is carried out. If it's found and it's an older version, the expected version is
installed in replacement of the previously found one. If it's not found, the expected version is
installed. After `drake` is installed, a sanity check is performed to ensure that the installed
version is exactly the version specified in [`DRAKE_VERSION.txt`](DRAKE_VERSION.txt) (and thus
the version we attempted to install in the first place).

## How to use it

```cmake
find_package(drake_vendor REQUIRED)

# ...

add_library(my_lib my_lib.cc)

target_link_libraries(my_lib
   drake::drake
)
```

Note that upon a `find_package(drake_vendor)` invocation, `drake` imported targets 
are exposed so as to make it equivalent to a `find_package(drake)` invocation.

## How to check the target Drake version

After entering your workspace, building it, and executing `source ./install/setup.bash`, run:

```
which-drake
```

## How to change the target Drake version

1. Select a Drake SHA that you would like to use. Ensure it is the last commit
   of a nightly release, see
   [nightly build](https://drake-jenkins.csail.mit.edu/view/Nightly%20Production/).
2. In your local clone of `drake_vendor`, update `drake_version.txt` to match the 
   chosen commit date SHA.
3. Re-install `drake_vendor` prerequisites in your workspace:
   
   ```sh
   sudo prereqs-install -t all path/to/drake_vendor
   ```

4. Open a PR with the change into this repository and merge it into master.
