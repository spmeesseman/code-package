
@echo off
cd %~dp0

set pj=""
if "%1" == "--pj" (
    set pj=--pj
)
if "%2" == "--pj" (
    set pj=--pj
)


if "%pj%" == "--pj" (
    copy /Y VSCode_64bit.nsi VSCode_64bit.nsi.tmp
    rem use pj header
    cscript //B ..\script\substitute.vbs installerhdr.bmp pja24bit.bmp VSCode_64bit.nsi > VSCode_64bit.nsi.new
    rem // pj package owner
    cscript //B ..\script\substitute.vbs "Scott Meesseman" "Perry Johnson & Associates" VSCode_64bit.nsi.new > VSCode_64bit.nsi.new2
    rem pj download url (not ready yet, use test download links)
    rem cscript //B ..\script\substitute.vbs "https://github.com/spmeesseman/code-package/blob/master/src" "https://svn.development.pjats.com/code-package/src" VSCode_64bit.nsi.new2 > VSCode_64bit.nsi.new3
    move /Y VSCode_64bit.nsi.new2 VSCode_64bit.nsi
    rem move /Y VSCode_64bit.nsi.new3 VSCode_64bit.nsi
    rem del /Q VSCode_64bit.nsi.new2
    del /Q VSCode_64bit.nsi.new
)

rem CI skip edit files
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

rem Extract nsis for use, this will not be included in installer, nsi script will use "/x nsis" to exclude it
if not exist ..\build\nsis\  (
    ..\script\7za.exe e -tzip ..\src\nsis\nsis.zip -o..\build -r -spf
)

rem Compile the Setup script
..\build\nsis\makensis VSCode_64bit.nsi

if "%pj%" == "--pj" (
    move /Y VSCode_64bit.nsi.tmp VSCode_64bit.nsi
)
