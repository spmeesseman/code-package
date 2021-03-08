
@echo off
cd %~dp0

set pj=""
if "%1" == "--pj" (
    set pj=--pj
)
if "%2" == "--pj" (
    set pj=--pj
)

set OutputDirectory=..\build

rmdir /Q /S %OutputDirectory%
mkdir %OutputDirectory%

rem **********************************************************************
rem *                                                                    *
rem *  Git                                                               *
rem *                                                                    *
rem **********************************************************************

copy /Y git\git.inf %OutputDirectory%

rem **********************************************************************
rem *                                                                    *
rem *  Python                                                            *
rem *                                                                    *
rem **********************************************************************

if "%pj%" == "" (
    mkdir %OutputDirectory%\python
    mkdir %OutputDirectory%\tmp
    ..\script\7za.exe e -tzip python/python.zip -o%OutputDirectory%\tmp -r -spf
    move %OutputDirectory%\tmp\python\python37._pth %OutputDirectory%\python\python37._pth.save
    copy /Y python\python37._pth %OutputDirectory%\python
    copy /Y python\install_pip.bat %OutputDirectory%\python
    copy /Y python\get-pip.py %OutputDirectory%\python
    rmdir /Q /S %OutputDirectory%\tmp
)

rem **********************************************************************
rem *                                                                    *
rem *  Custom scripts                                                    *
rem *                                                                    *
rem **********************************************************************

xcopy custom\* %OutputDirectory% /s /i /y

