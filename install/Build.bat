
@echo off
cd %~dp0

set pj=""
if "%1" == "--pj" (
    set pj=--pj
)
if "%2" == "--pj" (
    set pj=--pj
)

rem CI skip edit files
if "%1" == "--edit-files" (
    rem Edit the History
    notepad history.txt

    rem Edit the Installation document
    rem "..\doc\Code Installation.docx"

    rem Edit the Setup script
    if "%pj%" == "--pj" (
        notepad code-package-pjats-x64.nsi
    ) else (
        notepad code-package-x64.nsi
    )
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
if "%pj%" == "--pj" (
    ..\build\nsis\makensis code-package-pjats-x64.nsi
) else (
    ..\build\nsis\makensis code-package-x64.nsi
)
