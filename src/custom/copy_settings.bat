
@echo off

rem if exist %APPDATA%\Code\User\settings.json  (
rem     del /Q /F settings.json
rem )
rem else (
rem     move /Y settings.json %APPDATA%\Code\User
rem )

rem if exist %APPDATA%\Code\User\keybindings.json  (
rem     del /Q /F keybindings.json
rem )
rem else (
rem     move /Y keybindings.json %APPDATA%\Code\User
rem )

if exist nodejs\node_modules\eslint\.eslintrc.json  (
    del /Q /F .eslintrc.json
)
else (
    move /Y .eslintrc.json nodejs\node_modules\eslint
)
