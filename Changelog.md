# Changelog

## Major.Minor.Patch - YYYY-MM-DD

### API changes
- ...

### New features
- ...

### Bug fixes
- ...

### Known issues
- ...


## 0.18.20206013-1 - 2021-01-19

### API changes
- Versioned installation in /opt/drake/<version>, [PR #23](https://github.com/ToyotaResearchInstitute/drake-vendor/pull/23)
- No longer blocks with a build of drake_vendor, [PR #23](https://github.com/ToyotaResearchInstitute/drake-vendor/pull/23)
- Blocks more strictly when downstream packages try to depend on drake_vendor, [PR #23](https://github.com/ToyotaResearchInstitute/drake-vendor/pull/23)

### New features

- Can now fetch semantic version releases (fallback still nightly snapshots), [PR #23](https://github.com/ToyotaResearchInstitute/drake-vendor/pull/23)
- Installation logic shifted from prereqs to drake-installer utility, [PR #23](https://github.com/ToyotaResearchInstitute/drake-vendor/pull/23)


### Known issues
- Drake still does not yet expose it's version via CMake

-----------------------
