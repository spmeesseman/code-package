Change Log

## [2.0.3](https://github.com/spmeesseman/code-package/compare/v2.0.2...v2.0.3) (2019-05-14)


### Build System

* **nsis:** add nuget cli download [skip ci] ([25a752d](https://github.com/spmeesseman/code-package/commit/25a752d))
* **npm:** fix invalid attribute publisher->author [skip ci] ([649b686](https://github.com/spmeesseman/code-package/commit/649b686))
* update size param in registry uninstall section [skip ci] ([76ade40](https://github.com/spmeesseman/code-package/commit/76ade40))
* updated deploy file ([2264a5d](https://github.com/spmeesseman/code-package/commit/2264a5d))


### Code Refactoring

* remove verbosity bump in common.nsh ([58b8cc9](https://github.com/spmeesseman/code-package/commit/58b8cc9))


### Documentation

* **readme:** update builds list [skip ci] ([cb5f0e0](https://github.com/spmeesseman/code-package/commit/cb5f0e0))

## [2.0.2](https://github.com/spmeesseman/code-package/compare/v2.0.1...v2.0.2) (2019-04-25)

## [2.0.1](https://github.com/spmeesseman/code-package/compare/v2.0.0...v2.0.1) (2019-04-22)


### Bug Fixes

* insiders edition install does not include extensions ([f96128d](https://github.com/spmeesseman/code-package/commit/f96128d))


### Documentation

* **readme:** update build by me section ([6e818ce](https://github.com/spmeesseman/code-package/commit/6e818ce))

# [2.0.0](https://github.com/spmeesseman/code-package/compare/v1.3.2...v2.0.0) (2019-04-21)


### Build System

* extract nsis on demand when building installer, remove unzipped files under src ([727f453](https://github.com/spmeesseman/code-package/commit/727f453))
* fix python dir extraction for pip install ([3ba6f88](https://github.com/spmeesseman/code-package/commit/3ba6f88))
* fix soacing in update mode dialog box text on init ([76aa194](https://github.com/spmeesseman/code-package/commit/76aa194))
* **nsis:** general cleanup and first few alpha fixes ([f525763](https://github.com/spmeesseman/code-package/commit/f525763))
* **installer:** not sure what to do with branded pj installer yet, may just set up svn external ([1df5e29](https://github.com/spmeesseman/code-package/commit/1df5e29))
* progress v2 check in, all downloads initially added to nsis script ([18732c1](https://github.com/spmeesseman/code-package/commit/18732c1))
* **dotfuscator:** removed, not licensed for distribution. ([ba17d06](https://github.com/spmeesseman/code-package/commit/ba17d06))
* uninstaller - move settings dekete at the end of code uninstall section ([1a9bd60](https://github.com/spmeesseman/code-package/commit/1a9bd60))
* update branch name for downloads ([8ca4952](https://github.com/spmeesseman/code-package/commit/8ca4952))
* update message box content on init ([f98aac9](https://github.com/spmeesseman/code-package/commit/f98aac9))
* v2 progress ([2534417](https://github.com/spmeesseman/code-package/commit/2534417))


### Features

* installer should download packages instead of including localy. ([43fcdf4](https://github.com/spmeesseman/code-package/commit/43fcdf4))
* use checkbox type insatllation for selecting packages. ([17b555f](https://github.com/spmeesseman/code-package/commit/17b555f))


### BREAKING CHANGES

* Dotfuscator CE no longer available by direct download, available to registered users only with internal manually entered URL.  Bump major version number

## [1.3.2](https://github.com/spmeesseman/code-package/compare/v1.3.1...v1.3.2) (2019-04-15)


### Bug Fixes

* insiders edition desktop link after install is invalid ([402660f](https://github.com/spmeesseman/code-package/commit/402660f))

## [1.3.1](https://github.com/spmeesseman/code-package/compare/v1.3.0...v1.3.1) (2019-04-14)


### Bug Fixes

* insider install installs stable version not insider ([e5e3d15](https://github.com/spmeesseman/code-package/commit/e5e3d15))

# [1.3.0](https://github.com/spmeesseman/code-package/compare/v1.2.1...v1.3.0) (2019-04-14)


### Bug Fixes

* **nsis:** installer wipes out path.  package large string version of nsis (8096 bytes as compared to 1024) ([9106a61](https://github.com/spmeesseman/code-package/commit/9106a61))


### Build System

* **nsis:** add commeted lines back for possible switch back to user data directories instead of thumbnail method [skip ci] ([b6811a7](https://github.com/spmeesseman/code-package/commit/b6811a7))
* **package:** add nsis v3.04 files [skip ci] ([b8167d0](https://github.com/spmeesseman/code-package/commit/b8167d0))
* **python:** auto install pylint [skip ci] ([ceb458b](https://github.com/spmeesseman/code-package/commit/ceb458b))
* **nsis:** cleanup [skip ci] ([aa33d14](https://github.com/spmeesseman/code-package/commit/aa33d14))
* **nsis:** cleanup, error checks on downloads, check previous installs, add code insiders optional download [skip ci] ([9b376f5](https://github.com/spmeesseman/code-package/commit/9b376f5))
* final changes for 1.3 installer, fix settings.json copy ([cda0a1c](https://github.com/spmeesseman/code-package/commit/cda0a1c))
* **package:** final nsis3.04 touch up add files not included in installer [skip ci] ([5f085fd](https://github.com/spmeesseman/code-package/commit/5f085fd))
* fix build task build file updated to batch file from ant ([2628107](https://github.com/spmeesseman/code-package/commit/2628107))
* **vscode:** include vscode-vsauncher extension ([2dde439](https://github.com/spmeesseman/code-package/commit/2dde439))
* **nsis:** set scipt back to nsis file set from installer [skip ci] ([abf4d23](https://github.com/spmeesseman/code-package/commit/abf4d23))
* **pj:** update info [skip ci] ([61bc705](https://github.com/spmeesseman/code-package/commit/61bc705))


### Code Refactoring

* add extension humao.rest-client ([9f1495b](https://github.com/spmeesseman/code-package/commit/9f1495b))
* add/remove extensions ([3365b04](https://github.com/spmeesseman/code-package/commit/3365b04))
* **settings:** change to user directory settings from thumbnail settings. ([9ab49ec](https://github.com/spmeesseman/code-package/commit/9ab49ec))


### Documentation

* **history:** add 1.2.2 info ([2fc966a](https://github.com/spmeesseman/code-package/commit/2fc966a))
* **readme:** add Greenkeeper badge ([0853448](https://github.com/spmeesseman/code-package/commit/0853448))
* **readme:** update gk badge [skip ci] ([ce4795d](https://github.com/spmeesseman/code-package/commit/ce4795d))
* **history:** update to 1.3.0 info ([00ebfaa](https://github.com/spmeesseman/code-package/commit/00ebfaa))


### Features

* add gradle package ([a57047b](https://github.com/spmeesseman/code-package/commit/a57047b))

## [1.2.1](https://github.com/spmeesseman/code-package/compare/v1.2.0...v1.2.1) (2019-04-08)


### Build System

* **nsis:** increment to next semantiv version ([ef826eb](https://github.com/spmeesseman/code-package/commit/ef826eb))


### Code Refactoring

* auto enable git auto fetch setting ([618d22f](https://github.com/spmeesseman/code-package/commit/618d22f))


### Documentation

* **readme:** small update to test ci trigger ([8d7a849](https://github.com/spmeesseman/code-package/commit/8d7a849))
* **readme:** update software distribution tables [skip ci] ([80fc547](https://github.com/spmeesseman/code-package/commit/80fc547))

# [1.2.0](https://github.com/spmeesseman/code-package/compare/v1.1.0...v1.2.0) (2019-04-08)


### Build System

* **git:** fix silent installer option ([1013066](https://github.com/spmeesseman/code-package/commit/1013066))
* **nsis:** increment to next semantic version ([9f41ac5](https://github.com/spmeesseman/code-package/commit/9f41ac5))


### Documentation

* **history:** update with git install ([8358f42](https://github.com/spmeesseman/code-package/commit/8358f42))


### Features

* add git ([80771ef](https://github.com/spmeesseman/code-package/commit/80771ef))

# [1.1.0](https://github.com/spmeesseman/code-package/compare/v1.0.8...v1.1.0) (2019-04-08)


### Bug Fixes

* **2:** uninstall of tortoisesvn and .net 472 dev pack.  invalid pythonpath ([c1f4b12](https://github.com/spmeesseman/code-package/commit/c1f4b12))


### Build System

* **npm:** add custom tasks for pj build ([a662c5a](https://github.com/spmeesseman/code-package/commit/a662c5a))
* add helper scripts ([f932a75](https://github.com/spmeesseman/code-package/commit/f932a75))
* **sript:** add pythin extraction ([9740a76](https://github.com/spmeesseman/code-package/commit/9740a76))
* **nsis:** custom actions for pj build ([f938ef3](https://github.com/spmeesseman/code-package/commit/f938ef3))
* **npm:** move semantic rlease config to releaserc.json, rename to code-package ([b9d6665](https://github.com/spmeesseman/code-package/commit/b9d6665))
* **nsis:** publisher replace for pj build ([ef86cab](https://github.com/spmeesseman/code-package/commit/ef86cab))
* **installer:** update header image to 24bit no color space info ([e6dd1be](https://github.com/spmeesseman/code-package/commit/e6dd1be))
* **nsis:** update script for pythin installation ([175206f](https://github.com/spmeesseman/code-package/commit/175206f))
* **nsis:** update version # to next semantic version ([1e7af11](https://github.com/spmeesseman/code-package/commit/1e7af11))


### Code Refactoring

* **vscode:** add new extensions todo+ and python ([2e6e03c](https://github.com/spmeesseman/code-package/commit/2e6e03c))
* **installer:** new header image ([35e8b47](https://github.com/spmeesseman/code-package/commit/35e8b47))


### Documentation

* **history:** update Issue 4 ([fe08949](https://github.com/spmeesseman/code-package/commit/fe08949))
* **history:** updated version info ([1f52e8f](https://github.com/spmeesseman/code-package/commit/1f52e8f))


### Features

* add python package ([a590be5](https://github.com/spmeesseman/code-package/commit/a590be5))

## [1.0.8](https://github.com/spmeesseman/code-package/compare/v1.0.7...v1.0.8) (2019-04-07)


### Bug Fixes

* **build:** newline in message boxes displaying slash n ([35d26c3](https://github.com/spmeesseman/code-package/commit/35d26c3))

## [1.0.7](https://github.com/spmeesseman/code-package/compare/v1.0.6...v1.0.7) (2019-04-06)


### Bug Fixes

* uninstaller does not remove net472 devpack or tortoise if user selects remove ([95865bd](https://github.com/spmeesseman/code-package/commit/95865bd))

## [1.0.6](https://github.com/spmeesseman/code-package/compare/v1.0.5...v1.0.6) (2019-04-06)


### Bug Fixes

* azure pipelines build ([2816954](https://github.com/spmeesseman/code-package/commit/2816954))

## [1.0.5](https://github.com/spmeesseman/code-package/compare/v1.0.4...v1.0.5) (2019-03-20)

## [1.0.4](https://github.com/spmeesseman/codepackage/compare/v1.0.3...v1.0.4) (2019-03-19)

## [1.0.3](https://github.com/spmeesseman/codepackage/compare/v1.0.2...v1.0.3) (2019-03-19)

## [1.0.2](https://github.com/spmeesseman/codepackage/compare/v1.0.1...v1.0.2) (2019-03-19)

# 1.0.0 (2019-03-19)

# 1.0.0 (2019-03-19)

# 1.0.0 (2019-03-19)

# 1.0.0 (2019-03-19)
