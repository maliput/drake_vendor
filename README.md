# drake_vendor

## Overview

`drake_vendor` is an ament cmake shim for `drake`, easing its use in a `colcon` workspace
whether `drake` sources are part of the build or a binary distribution has been installed
on the system.

The version to be installed/upgraded is specified in the version element of `package.xml`.
It may be either a semantically versioned release (e.g. 1.25.0) or a nightly snapshot 
(20200613). Prefer semantically versioned releases since the drake team makes no guarantees
that nightly snapshots will be eternally available.

A verification file, `VERSION.TXT` is also provided to check that any installed version
matches the version specified in `package.xml`. This verification file will be deprecated
when the drake binary installation can advertise it's semantic version itself (see
[drake#14509](https://github.com/RobotLocomotion/drake/issues/14509).

## The Drake Installer Utility

A utility exists to assist with installing/upgrading drake and it's dependencies. Prior
to any installation/upgrade, it checks to see if a compatible version is already installed.
Post installation/upgrade, it will sanity check the newly installed version to check that it
matches against the `VERSION.TXT` stored in this repo.

```bash
$ sudo ./drake-installer --help
# Go with defaults, installs to /opt/drake
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

## The Drake Version Utility

Another utility is provided to quickly return the contents of the installed drake's
`VERSION.TXT` file:

```
$ drake-version
20200613074556 8d92fae6584f237e5d0989653c0b5915387444bf
```

## Depending on drake via drake_vendor

CMake extras are provided to ensure the correct checks are made and targets
are imported from drake when this package is dependend upon by downstream packages.


```cmake
# This in turn redirects to find_package(drake)
find_package(drake_vendor REQUIRED)

# ...

add_library(my_lib my_lib.cc)

target_link_libraries(my_lib
   drake::drake
)
```

## How to change the target Drake version

1. Set the version element of `package.xml` to the release you'd like to use.
    * Use `major.minor.patch` for a semantically versioned release, e.g. `1.25.0`
    * Use `0.0.yyyymmdd` for a nightly snapshot release, e.g. `0.0.20200613`
2. Update the verification file `VERSION.TXT` with the version file from the release
3. Test installation of the upgraded release with `sudo ./drake-installer --interactive`
4. Open a PR with the changes

   
   ```sh
   sudo prereqs-install -t all path/to/drake_vendor
   ```
