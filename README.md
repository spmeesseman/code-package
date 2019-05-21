# Bundled Visual Studio Code Development Environment

[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)
[![Greenkeeper badge](https://badges.greenkeeper.io/spmeesseman/code-package.svg?token=d5ee317b562beed19aaa376b57290da1622c76d687092eb10b1d301dbdbbfb1b&ts=1555022335792)](https://greenkeeper.io/)

> Bundles several 3rd party libraries and development tools to be used within the Visual Sudio Code IDE.  Install and go!

## Installing Visual Studio Code Updates

This package downloads and installs the latest version VSCode at the time of installation, using the zip archive.  To update Visual Studio Code when new versions are released, simply extract the new version's zip archive over top of the base Code Package installation.  Do not use the VSCode executable installer.

## Redistributed Software (included)

The following software is redistributed locally by code-package:

|Package|Version|License|Required|
|-|-|-|-|-|
|Apache Ant|1.10.5|Apache 2.0|No|
|Ansicon|1.88|Jason Hood|No|
|Dotfuscator|5.26.0|GPL-compatible|No|
|Gradle|5.3.1|GPL|No|
|NodeJS|10.15.3|Node.js|Yes|
|PHP|7.3.5|GPL-compatible|No|
|Python|3.7.3|GPL-compatible|No|
|Tortoise SVN|1.11.1|GPLv2|No|

## Remote/Downloaded Software (non-redistributed)

The following software is not included and is not redistributed locally within code-package, but downloaded inline and installed at the user's discretion:

|Redistributable|Version|Method|License|Required|
|-|-|-|-|-|
|VSCode|Latest|Online|Microsft VSCode|Yes|
|VSCode Extensions|Latest|Online|N/A|Yes|
|.NET Targeting Pack|4.72|Online|Microsoft|No|
|Git for Windows|2.21.0|Online|GPLv2|No|
