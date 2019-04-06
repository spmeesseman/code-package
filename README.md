# Bundled Visual Studio Code Development Environment

[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)
[![Known Vulnerabilities](https://snyk.io/test/github/spmeesseman/code-package/badge.svg)](https://snyk.io/test/github/spmeesseman/code-package)
[![Average time to resolve an issue](https://isitmaintained.com/badge/resolution/spmeesseman/code-package.svg)](https://isitmaintained.com/project/spmeesseman/code-package "Average time to resolve an issue")
[![Percentage of issues still open](https://isitmaintained.com/badge/open/spmeesseman/code-package.svg)](https://isitmaintained.com/project/spmeesseman/code-package "Percentage of issues still open")
[![Dependencies Status](https://david-dm.org/spmeesseman/code-package/status.svg)](https://david-dm.org/spmeesseman/code-package)
[![DevDependencies Status](https://david-dm.org/spmeesseman/code-package/dev-status.svg)](https://david-dm.org/spmeesseman/code-package?type=dev)

> Bundles several 3rd party libraries and development tools to be used within the Visual Sudio Code IDE.  The latest version of VSCode and the .NET 4.72 Targeting Pack are downloaded and installed by the installer.

## Installing Visual Studio Code Updates

This package downloads and installs VSCode using the zip archive.  To update Visual Studio Code, simply extract the new version's zip archive over top of the base Code Package installation.  Do not use the VSCode installer.

## Redistributed Software (included)

The following software is redistributed locally by code-package:

|Redistributable|Version|Method|License|
|-|-|-|-|
|Tortoise SVN|1.11.1|Local|GPL|
|Apache Ant|1.10.5|Local|Apache 2.0|
|Ansicon|1.88|Local|Jason Hood|
|NodeJS|10.15.3|Local|Node.js|

## Remote/Downloaded Software (non-redistributed)

The following software is not included and redistributed locally within code-package, but downloaded inline and installed:

|Redistributable|Version|Method|License|
|-|-|-|-|
|VSCode|Latest|Online|Microsft VSCode|
|VSCode Extensions|Latest|Online|N/A|
|.NET Targeting Pack|4.72|Online|Microsoft|

## Feedback & Contributing

* Please report any bugs, suggestions or documentation requests via the
  [Issues](https://github.com/spmeesseman/code-package/issues)
* Feel free to submit
  [pull requests](https://github.com/spmeesseman/code-package/pulls)
* [Contributors](https://github.com/spmeesseman/code-package/graphs/contributors)
