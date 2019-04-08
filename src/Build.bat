
rem @echo off
cd %~dp0

set OutputDirectory=..\build

rmdir /Q /S %OutputDirectory%
mkdir %OutputDirectory%


rem **********************************************************************
rem *                                                                    *
rem *  C, C++ and C# Compilers                                           *
rem *                                                                    *
rem **********************************************************************

..\script\7za.exe e -tzip compilers\c_c++\9.0.zip -o%OutputDirectory%\compilers\c_c++ -r -spf
..\script\7za.exe e -tzip compilers\c#\8.0.zip -o%OutputDirectory%\compilers\c# -r -spf
..\script\7za.exe e -tzip compilers\c#\15.0.zip -o%OutputDirectory%\compilers\c# -r -spf


rem **********************************************************************
rem *                                                                    *
rem *  APACHE Ant                                                        *
rem *                                                                    *
rem **********************************************************************

..\script\7za.exe e -tzip ant/apache-ant-1.10.5-bin.zip -o%OutputDirectory% -r -spf
move /Y %OutputDirectory%\apache-ant-1.10.5 %OutputDirectory%\ant



rem **********************************************************************
rem *                                                                    *
rem *  Ansicon (for Ant)                                                 *
rem *                                                                    *
rem **********************************************************************

..\script\7za.exe e -tzip ansicon/ansi188-bin.zip -o%OutputDirectory%\ansicon -r -spf


rem **********************************************************************
rem *                                                                    *
rem *  Node JS                                                           *
rem *                                                                    *
rem **********************************************************************

..\script\7za.exe e -tzip nodejs/node-v10.15.3-win-x64.zip -o%OutputDirectory% -r -spf
move /Y %OutputDirectory%\node-v10.15.3-win-x64 %OutputDirectory%\nodejs


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

..\script\7za.exe e -tzip python/python-3.7.3-embed-amd64.zip -o%OutputDirectory%\python -r -spf
move %OutputDirectory%\python\python37._pth %OutputDirectory%\python\python37._pth.save
copy /Y python\python37._pth %OutputDirectory%\python
copy /Y python\install_pip.bat %OutputDirectory%\python
copy /Y python\get-pip.py %OutputDirectory%\python


rem **********************************************************************
rem *                                                                    *
rem *  NullSoft Installer                                                *
rem *                                                                    *
rem **********************************************************************

xcopy nsis\* %OutputDirectory%\nsis /s /i /y

rem **********************************************************************
rem *                                                                    *
rem *  Tortoise SVN Installer                                            *
rem *                                                                    *
rem **********************************************************************

xcopy tortoisesvn\* %OutputDirectory% /s /i /y


rem **********************************************************************
rem *                                                                    *
rem *  SDK Files                                                         *
rem *                                                                    *
rem **********************************************************************

xcopy sdks\* %OutputDirectory%\sdks /s /i /y
..\script\7za.exe e -tzip dotnet/v4.7.2.zip -o%OutputDirectory%\sdks\net472 -r -spf
..\script\7za.exe e -tzip dotnet/v4.6.1.zip -o%OutputDirectory%\sdks\net461 -r -spf
..\script\7za.exe e -tzip dotnet/v4.5.2.zip -o%OutputDirectory%\sdks\net452 -r -spf
..\script\7za.exe e -tzip dotnet/v4.0.zip -o%OutputDirectory%\sdks\net40 -r -spf
..\script\7za.exe e -tzip dotnet/v3.5.zip -o%OutputDirectory%\sdks\net35 -r -spf


rem **********************************************************************
rem *                                                                    *
rem *  Custom scripts                                                    *
rem *                                                                    *
rem **********************************************************************

xcopy custom\* %OutputDirectory% /s /i /y

