# drake_vendor

Ament CMake shim package for drake.

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
