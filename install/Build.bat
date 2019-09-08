
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
    copy /Y code-package-x64.nsi code-package-x64.nsi.tmp
    rem use pj header
    cscript //B ..\script\substitute.vbs installerhdr.bmp pja24bit.bmp code-package-x64.nsi > code-package-x64.nsi.new
    rem // pj package owner
    cscript //B ..\script\substitute.vbs "Scott Meesseman" "Perry Johnson & Associates" code-package-x64.nsi.new > code-package-x64.nsi.new2
    rem pj download url (not ready yet, use test download links)
    rem cscript //B ..\script\substitute.vbs "https://github.com/spmeesseman/code-package/blob/master/src" "https://svn.development.pjats.com/code-package/src" code-package-x64.nsi.new2 > code-package-x64.nsi.new3
    move /Y code-package-x64.nsi.new2 code-package-x64.nsi
    rem move /Y code-package-x64.nsi.new3 code-package-x64.nsi
    rem del /Q code-package-x64.nsi.new2
    del /Q code-package-x64.nsi.new
)

rem CI skip edit files
if "%1" == "--edit-files" (
    rem Edit the History
    notepad history.txt

    rem Edit the Installation document
    rem "..\doc\Code Installation.docx"

    rem Edit the Setup script
    notepad code-package-x64.nsi
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
..\build\nsis\makensis code-package-x64.nsi

if "%pj%" == "--pj" (
    move /Y code-package-x64.nsi.tmp code-package-x64.nsi
)
