# drake_vendor

## Overview

`drake_vendor` is an ament cmake shim for a binary installation of `drake`,
easing its use in a `colcon` workspace.

## Basic Usage - Depending on Drake

Make sure drake is installed with the version specified in `drake_vendor/package.xml`
(this requires `drake_vendor` itself to have been installed already):

```bash
sudo drake-installer
```

Mark a dependency on `drake_vendor` in downstream's `package.xml`:

```xml
<build_depend>drake_vendor</build_depend>
```

Look for `drake_vendor` via CMake and use drake's imported targets as dependencies for
your libraries/applications.

```cmake
find_package(drake_vendor REQUIRED)

# ...

add_library(my_lib my_lib.cc)

target_link_libraries(my_lib
   drake::drake
)
```

## Detailed Information

The version to be installed/upgraded is specified in the version element of `package.xml`.
It may be either a semantically versioned release (e.g. 0.18.0) or a nightly snapshot 
(0.18.20200613). Semantically versioned releases are preferred since the drake team makes
no guarantees that nightly snapshots will be eternally available.

A verification file, `VERSION.TXT` is also provided to check that any installed version
matches the version specified in `package.xml`. This is used by both the `drake-installer`
utility for a post-installation check and the exported `drake_vendor` cmake modules to
verify the discovered drake is the correct version. This verification file will be
deprecated when the drake binary installation can advertise it's semantic version itself
(see [drake#14509](https://github.com/RobotLocomotion/drake/issues/14509).

## Advanced Usage

### Specifying a Different Version

* Fork/branch `drake_vendor`
* Include your fork/branch of `drake_vendor` in your workspace
* Update the version in `drake_vendor/package.xml`
  * Use `major.minor.patch` for a semantically versioned release, e.g. `0.18.0`
  * Use `major.minor.yyyymmdd` for a nightly snapshot release, e.g. `0.18.20200613`
* Update the verification file `VERSION.TXT` with the version file from the release
* Build and install `drake_vendor`
* Execute `sudo drake-installer`, this will install to `/opt/drake/<your-new-version>`
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

### The drake-installer Utility

A utility exists to assist with installing/upgrading drake and it's dependencies. Prior
to any installation/upgrade, it checks to see if a compatible version is already installed.
Post installation/upgrade, it will sanity check the newly installed version to check that it
matches against the `VERSION.TXT` stored in this repo.

```bash
$ sudo ./drake-installer --help

# Install with defaults:
#  Version: as specified in package.xml
#  Install directory: /opt/drake/<version>
#  Distro: as specified by /etc/os-release
$ sudo ./drake-installer
Installation Details
  Drake Version................20200613
  Ubuntu Distro................bionic
  Verification File............/home/snorri/workspace/src/drake_vendor/VERSION.TXT
  Installation Directory......./opt/drake
  Existing Installation........UNINSTALLED
Fetching https://drake-packages.csail.mit.edu/drake/nightly/drake-20200613-bionic.tar.gz and saving to /tmp/drake.tar.gz
Extracting /tmp/drake.tar.gz into /opt/drake
```

## The drake-version Utility

Another utility is provided to quickly return the contents of the installed drake's
`VERSION.TXT` file:

```
$ drake-version
20200613074556 8d92fae6584f237e5d0989653c0b5915387444bf
```
