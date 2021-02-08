# Bundled Visual Studio Code Development Environment

[![app-type](https://img.shields.io/badge/category-dev%20env-blue.svg)](https://www.perryjohnson.com)
[![app-lang](https://img.shields.io/badge/language-javascript%20c%23%20php%20python%20c-blue.svg)](https://www.perryjohnson.com)
[![app-publisher](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-app--publisher-e10000.svg)](https://app1.development.pjats.com/projects/set_project.php?project=Gapp-publisher&make_default=no)

[![authors](https://img.shields.io/badge/authors-scott%20meesseman-6F02B5.svg?logo=visual%20studio%20code)](https://github.com/perryjohnsoninc)
[![MantisBT issues open](https://app1.development.pjats.com/projects/plugins/ApiExtend/api/issues/countbadge/code-package/open)](https://app1.development.pjats.com/projects/set_project.php?project=code-package&make_default=no&ref=plugin.php?page=Releases/releases)
[![MantisBT issues closed](https://app1.development.pjats.com/projects/plugins/ApiExtend/api/issues/countbadge/code-package/closed)](https://app1.development.pjats.com/projects/set_project.php?project=code-package&make_default=no&ref=plugin.php?page=Releases/releases)
[![MantisBT version current](https://app1.development.pjats.com/projects/plugins/ApiExtend/api/versionbadge/code-package/current)](https://app1.development.pjats.com/projects/set_project.php?project=code-package&make_default=no&ref=plugin.php?page=Releases/releases)
[![MantisBT version next](https://app1.development.pjats.com/projects/plugins/ApiExtend/api/versionbadge/code-package/next)](https://app1.development.pjats.com/projects/set_project.php?project=code-package&make_default=no&ref=plugin.php?page=Releases/releases)

- [Bundled Visual Studio Code Development Environment](#bundled-visual-studio-code-development-environment)
  - [Description](#description)
  - [Install](#install)
  - [Visual Studio Code and Package Updates](#visual-studio-code-and-package-updates)
  - [Redistributed Software](#redistributed-software)
  - [Remote/Downloaded Software (non-redistributed)](#remotedownloaded-software-non-redistributed)

## Description

Bundles several 3rd party libraries and development tools along with the latest version of Visual Studio Code at the time of installation.  The installation performs a *thumbdrive* installation type using the Visual Studio Code ZIP archive.

## Install

To install **code-package**, run the installer executable and select the desired packages for installation when prompted.  **Visual Studio Code** will be installed by default.  Unless you are licensed for Dotfuscator, uncheck the Dotfuscator option in the list of available packages before starting the installation.

## Visual Studio Code and Package Updates

To update to the latest versions of VSCode, or any other included package that has been updated to a newer version, simply run the "Change..." installation option in the Windows Add/Remove Programs List.  Ensure that all instances of VSCode are shut down before proceeding.

![addremove-change](https://app1.development.pjats.com/svn/web/filedetails.php?repname=pja&path=/code-package/trunk/res/img/addremove-change.png&usemime=1)

Click OK when prompted to update packages.

![addremove-change-prompt](https://app1.development.pjats.com/svn/web/filedetails.php?repname=pja&path=/code-package/trunk/res/img/addremove-change-prompt.png&usemime=1)

Select "Visual Studio Code" for updating before proceeding.

![addremove-change-update](https://app1.development.pjats.com/svn/web/filedetails.php?repname=pja&path=/code-package/trunk/res/img/addremove-change-update.png&usemime=1)

## Redistributed Software

The following software is redistributed by code-package, downloaded and installed at runtime if the particular package has been selected for installation.

|Package|Version|License|Required|
|---|---|---|---|
|Apache Ant|1.10.7|Apache 2.0|No|
|Ansicon|1.89|Jason Hood|No|
|Gradle|5.3.1|GPL|No|
|NodeJS|10.22.1|Node.js|Yes|
|PHP|7.3.9 (NTS)|GPL-compatible|No|
|PHP Composer||GPL-compatible|No|
|Python|3.7.3|GPL-compatible|No|
|Tortoise SVN|1.12.2|GPLv2|No|

## Remote/Downloaded Software (non-redistributed)

The following software is not included and is not redistributed locally within code-package, but downloaded inline and installed at the user's discretion:

|Redistributable|Version|Method|License|Required|
|-|-|-|-|-|
|VSCode|Latest|Online|Microsft VSCode|Yes|
|VSCode Extensions|Latest|Online|N/A|Yes|
|.NET Targeting Pack|4.72|Online|Microsoft|No|
|Git for Windows|2.21.0|Online|GPLv2|No|
