
@echo off
cd %~dp0

if "%1" == "--edit-files" (
    rem Edit the History
    notepad history.txt

    rem Edit the Installation document
    rem "..\doc\Code Installation.docx"

    rem Edit the Setup script
    notepad VSCode_64bit.nsi
)

mkdir dist
mkdir ..\build
mkdir ..\build\data
mkdir ..\build\data\extensions
mkdir ..\build\data\user-data
mkdir ..\build\data\user-data\User

rem Compile the Setup script
..\src\nsis\makensis VSCode_64bit.nsi

rem Remove the build directory, leaving this around after building
rem the installer causes some issues with task scanning in VSCode
rem rmdir /Q /S ..\build
