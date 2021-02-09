# drake_vendor

## Overview

`drake_vendor` is an ament cmake shim for a binary installation of `drake`,
easing its use in a `colcon` workspace.

## Basic Usage - Downstream CMake Packages

**Step 1**: Install `drake_vendor` or include it in your workspace.

This package provides the cmake modules,
environment hooks and helper scripts to detect, install and
configure your workspace but *it does not install drake*. This comes
later.

It will also not block your build, i.e. merely having this package in
your workspace will not prevent a successful build. Blocking will only
occur if a downstream package tries to depend on `drake_vendor` and the
appropriate drake installation cannot be found. This is illustrated
via the ensuing steps.

**Step 2**: Depend on `drake_vendor`.

Mark a dependency on `drake_vendor` (not `drake`) in your package's
`package.xml`:

```xml
<build_depend>drake_vendor</build_depend>
```

**Step 3**: Import CMake targets.

Import `drake` targets via `drake_vendor`:

```cmake
find_package(drake_vendor REQUIRED)

# ...

add_library(my_lib my_lib.cc)

target_link_libraries(my_lib
   drake::drake
)
```

**Step 4**: Install `drake` (if not yet installed).

At this point, if you attempt to build your downstream package and
you do not have an installation of `drake` that matches the version
specified in `drake_vendor/package.xml`, the build will abort and you
will be provided with an informative error message:

```
CMake Error at /home/snorri/workspace/install/drake_vendor/share/drake_vendor/cmake/drake-extras.cmake:18 (message):
   =====================================================================
   No working drake installation found at /opt/drake/20200613.
   
   If none exists, use the drake_installer utility to install the
   required version. See also http://drake.mit.edu/installation.html.
   =====================================================================

Call Stack (most recent call first):
  /home/snorri/workspace/install/drake_vendor/share/drake_vendor/cmake/drake_vendorConfig.cmake:38 (include)
  CMakeLists.txt:15 (find_package)
```
Proceed to install drake:

```bash
# If drake_vendor is in your workspace
cd src/drake_vendor && ./drake_installer

# If drake_vendor is installed in an underlay
drake_installer
```

## Basic Usage - Downstream Python Packages

Steps 1 and 4 remain the same. The python workflow however, does not yet have the
infrastructure to verify and provide a friendly notification with instructions
when drake is not available. The first signal that a drake installation is missing
will occur when importing `pydrake`:

```
$ python3 -c 'import pydrake; print(pydrake.__file__)'
Traceback (most recent call last):
  File "<string>", line 1, in <module>
ModuleNotFoundError: No module named 'pydrake'
```

At that point, proceed to install drake following the preceding instructions in step 4.

## Versioning Info

The version specified in `drake_vendor/package.xml`
may be either a semantically versioned release (e.g. 0.18.0) or a nightly snapshot 
(0.18.20200613). Semantically versioned releases are preferred since the drake team makes
no guarantees that nightly snapshots will be eternally available.

The included verification file, `drake_vendor/VERSION.TXT` is used to confirm that an
installed version matches the version specified in `package.xml`. This is used by both
the `drake_installer` utility and the exported `drake_vendor` cmake modules to
verify the discovered drake is the correct version. This verification file will be
deprecated when the drake binary installation can advertise it's semantic version itself
(see [drake#14509](https://github.com/RobotLocomotion/drake/issues/14509)).

## Advanced Usage

### Requiring a Different Version

* Fork/branch `drake_vendor`
* Include your fork/branch of `drake_vendor` in your workspace
* Update the version in `drake_vendor/package.xml`
  * Use `major.minor.patch` for a semantically versioned release, e.g. `0.18.0`
  * Use `major.minor.yyyymmdd` for a nightly snapshot release, e.g. `0.18.20200613`
* Update the verification file `VERSION.TXT` with the version file from the release
* Build and install `drake_vendor`
* Execute `sudo drake_installer`, this will install to `/opt/drake/<your-new-version>`
* Be froody

### Redirecting to A Different Install Location

If you've installed drake to a location other than `/opt/drake/<version>`, then proceed
with the following steps to ensure `drake_vendor` is aware of it:

* Ensure your installed version matches the version in `drake_vendor/package.xml`
  * See above if you need to use a different version
* Include `drake_vendor` in your workspace
* Export the environment variable `DRAKE_INSTALL_PREFIX` to point at your installation
* Build and install `drake_vendor`
* Downstream packages should now discover drake correctly

## Utilities

### The drake_installer Utility

A utility exists to assist with installing/upgrading drake and its dependencies. Prior
to any installation/upgrade, it checks to see if a compatible version (provided via
the --version argument) is already installed. Post installation/upgrade, it will sanity
check the newly installed version to check that it matches against the `VERSION.TXT`
stored in this repo.

```bash
$ sudo ./drake_installer --help

# Install with defaults:
#  Version: as specified in package.xml
#  Install directory: /opt/drake/<version>
#  Distro: as specified by /etc/os-release
$ sudo ./drake_installer
Installation Details
  Drake Version................20200613
  Ubuntu Distro................bionic
  Verification File............/home/snorri/workspace/src/drake_vendor/VERSION.TXT
  Installation Directory......./opt/drake
  Existing Installation........UNINSTALLED
Fetching https://drake-packages.csail.mit.edu/drake/nightly/drake-20200613-bionic.tar.gz and saving to /tmp/drake.tar.gz
Extracting /tmp/drake.tar.gz into /opt/drake
```

## The drake_version Utility

Another utility is provided to quickly return the contents of the installed drake's
`VERSION.TXT` file:

```
$ drake_version
20200613074556 8d92fae6584f237e5d0989653c0b5915387444bf
```
