
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

if "%1" == "--pj" (
    copy /Y VSCode_64bit.nsi VSCode_64bit.nsi.tmp
    rem use pj header
    cscript //B ..\script\substitute.vbs installerhdr.bmp pja24bit.bmp VSCode_64bit.nsi > VSCode_64bit.nsi.new
    cscript //B ..\script\substitute.vbs "Scott Meesseman" "Perry Johnson & Associates" VSCode_64bit.nsi.new > VSCode_64bit.nsi.new2
    move /Y VSCode_64bit.nsi.new2 VSCode_64bit.nsi
    del /Q VSCode_64bit.nsi.new
)

mkdir dist
mkdir ..\build
rem mkdir ..\build\data
rem mkdir ..\build\data\extensions
rem mkdir ..\build\data\user-data
rem mkdir ..\build\data\user-data\User

rem update version to package.json
for /f %%i in ('..\build\nodejs\node -e "console.log(require('../package.json').version);"') do set version=%%i
echo Current package.json version is %version%
rem set /p newversion=Enter the new version #: 
rem echo New version is %newversion%
rem cscript //B ..\script\substitute.vbs %version% %newversion% VSCode_64bit.nsi > VSCode_64bit.nsi.new
rem move /Y VSCode_64bit.nsi.new VSCode_64bit.nsi

rem Compile the Setup script
..\src\nsis\makensis VSCode_64bit.nsi

rem Remove the build directory, leaving this around after building
rem the installer causes some issues with task scanning in VSCode
rem rmdir /Q /S ..\build

if "%1" == "--pj" (
    move /Y VSCode_64bit.nsi.tmp VSCode_64bit.nsi
)
