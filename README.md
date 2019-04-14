# Bundled Visual Studio Code Development Environment

[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)
[![Greenkeeper badge](https://badges.greenkeeper.io/spmeesseman/code-package.svg?token=d5ee317b562beed19aaa376b57290da1622c76d687092eb10b1d301dbdbbfb1b&ts=1555022335792)](https://greenkeeper.io/)
[![Known Vulnerabilities](https://snyk.io/test/github/spmeesseman/code-package/badge.svg)](https://snyk.io/test/github/spmeesseman/code-package)
[![Average time to resolve an issue](https://isitmaintained.com/badge/resolution/spmeesseman/code-package.svg)](https://isitmaintained.com/project/spmeesseman/code-package "Average time to resolve an issue")
[![Percentage of issues still open](https://isitmaintained.com/badge/open/spmeesseman/code-package.svg)](https://isitmaintained.com/project/spmeesseman/code-package "Percentage of issues still open")
[![Dependencies Status](https://david-dm.org/spmeesseman/code-package/status.svg)](https://david-dm.org/spmeesseman/code-package)
[![DevDependencies Status](https://david-dm.org/spmeesseman/code-package/dev-status.svg)](https://david-dm.org/spmeesseman/code-package?type=dev)

> Bundles several 3rd party libraries and development tools to be used within the Visual Sudio Code IDE.  Install and go!

## Installing Visual Studio Code Updates

This package downloads and installs the latest version VSCode at the time of installation, using the zip archive.  To update Visual Studio Code when new versions are released, simply extract the new version's zip archive over top of the base Code Package installation.  Do not use the VSCode executable installer.

## Redistributed Software (included)

The following software is redistributed locally by code-package:

|Redistributable|Version|Method|License|Required|
|-|-|-|-|-|
|Tortoise SVN|1.11.1|Local|GPLv2|No|
|Apache Ant|1.10.5|Local|Apache 2.0|Yes|
|Ansicon|1.88|Local|Jason Hood|Yes|
|NodeJS|10.15.3|Local|Node.js|Yes|
|Python|3.7.3|Local|GPL-compatible|Yes|

## Remote/Downloaded Software (non-redistributed)

The following software is not included and is not redistributed locally within code-package, but downloaded inline and installed at the user's discretion:

|Redistributable|Version|Method|License|Required|
|-|-|-|-|-|
|VSCode|Latest|Online|Microsft VSCode|Yes|
|VSCode Extensions|Latest|Online|N/A|Yes|
|.NET Targeting Pack|4.72|Online|Microsoft|No|
|Git for Windows|2.21.0|Online|GPLv2|No|

## Feedback & Contributing

* Please report any bugs, suggestions or documentation requests via the
  [Issues](https://github.com/spmeesseman/code-package/issues)
* Feel free to submit
  [pull requests](https://github.com/spmeesseman/code-package/pulls)
* [Contributors](https://github.com/spmeesseman/code-package/graphs/contributors)
