# Bundled Visual Studio Code Development Environment

[![app-type](https://img.shields.io/badge/category-dev%20env-blue.svg)](https://www.perryjohnson.com)
[![app-lang](https://img.shields.io/badge/language-javascript%20c%23%20php%20python%20c-blue.svg)](https://www.perryjohnson.com)
[![app-publisher](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-app--publisher-e10000.svg)](https://app1.development.pjats.com/projects/set_project.php?project=Gapp-publisher&make_default=no)

[![authors](https://img.shields.io/badge/authors-scott%20meesseman-6F02B5.svg?logo=visual%20studio%20code)](https://github.com/perryjohnsoninc)
[![MantisBT issues open](https://app1.development.pjats.com/projects/plugins/ApiExtend/api/issues/countbadge/GEMS2/open)](https://app1.development.pjats.com/projects/set_project.php?project=GEMS2&make_default=no&ref=plugin.php?page=Releases/releases)
[![MantisBT issues closed](https://app1.development.pjats.com/projects/plugins/ApiExtend/api/issues/countbadge/GEMS2/closed)](https://app1.development.pjats.com/projects/set_project.php?project=GEMS2&make_default=no&ref=plugin.php?page=Releases/releases)
[![MantisBT version current](https://app1.development.pjats.com/projects/plugins/ApiExtend/api/versionbadge/GEMS2/current)](https://app1.development.pjats.com/projects/set_project.php?project=GEMS2&make_default=no&ref=plugin.php?page=Releases/releases)
[![MantisBT version next](https://app1.development.pjats.com/projects/plugins/ApiExtend/api/versionbadge/GEMS2/next)](https://app1.development.pjats.com/projects/set_project.php?project=GEMS2&make_default=no&ref=plugin.php?page=Releases/releases)

- [Bundled Visual Studio Code Development Environment](#Bundled-Visual-Studio-Code-Development-Environment)
  - [Description](#Description)
  - [Installing Visual Studio Code Updates](#Installing-Visual-Studio-Code-Updates)
  - [Redistributed Software (included)](#Redistributed-Software-included)
  - [Remote/Downloaded Software (non-redistributed)](#RemoteDownloaded-Software-non-redistributed)

## Description

Bundles several 3rd party libraries and development tools to be used within the Visual Sudio Code IDE.  Install and go!

## Installing Visual Studio Code Updates

This package downloads and installs the latest version VSCode at the time of installation.  This installation uses the standalone installation type with the VSCode ZIP archive.

To update to the latest versions of VSCode, or any other included package that has been updated to a newer version, simply run the "Change..." installation option in the Windows Add/Remove Programs List.

[![addremove-change](res/img/addremove-change.png)]

Click OK when prompted to update packages.

[![addremove-change-prompt](res/img/addremove-change-prompt.png)]

Select "Visual Studio Code" for updating before proceeding.

[![addremove-change-update](res/img/addremove-change-update.png)]

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
