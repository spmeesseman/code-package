
;*********************************************************************
;*                                                                   *
;*   Define                                                          *
;*                                                                   * 
;*********************************************************************

; Define application name
!define APPLICATION_NAME     "Code Package"

; Define build level
!define BUILD_LEVEL          "2.0.0"

; Define install file name
!define INSTALL_FILE_NAME    "CodePackage_x64.exe"

; Define uninstall file name
!define UNINSTALL_FILE_NAME  "CodePackageUninstall.exe"

; Define MUI_ABORTWARNING so that a warning message is displayed
; if you attempt to cancel an install
!define MUI_ABORTWARNING

; Define MUI_HEADERPAGE to display a custom bitmap
!define MUI_ICON "code.ico"
!define MUI_HEADERIMAGE 
!define MUI_HEADERIMAGE_BITMAP "installerhdr.bmp"

; Set context to 'All Users'
!define ALL_USERS

!define CodeDownloadUrl "https://update.code.visualstudio.com/latest/win32-x64-archive/stable"
!define CodeInsidersDownloadUrl "https://update.code.visualstudio.com/latest/win32-x64-archive/insider"
!define GitDownloadUrl "https://github.com/git-for-windows/git/releases/download/v2.21.0.windows.1/Git-2.21.0-64-bit.exe"
!define Net472DownloadUrl "https://go.microsoft.com/fwlink/?LinkId=874338"
!define PackageBaseUrl "https://github.com/spmeesseman/code-package/blob/dl-installer/src"
!define TortoiseUrl "${PackageBaseUrl}/tortoisesvn/tortoisesvn.msi?raw=true"
!define DotfuscatorUrl "${PackageBaseUrl}/dotfuscator/ce.zip?raw=true"
!define NodeJsUrl "${PackageBaseUrl}/nodejs/nodejs.zip?raw=true"
!define NsisUrl "${PackageBaseUrl}/nsis/nsis.zip?raw=true"
!define PythonUrl "${PackageBaseUrl}/python/python.zip?raw=true"
!define AntUrl "${PackageBaseUrl}/ant/ant.zip?raw=true"
!define AnsiconUrl "${PackageBaseUrl}/ansicon/ansicon.zip?raw=true"
!define GradleUrl "${PackageBaseUrl}/gradle/gradle.zip?raw=true"
!define LegacyWixUrl "${PackageBaseUrl}/sdks/wix.zip?raw=true"
!define LegacyAtlMfcUrl "${PackageBaseUrl}/sdks/atlmfc.zip?raw=true"
!define LegacyWindows2009Url "${PackageBaseUrl}/sdks/windows/august2009.zip?raw=true"
!define Net35PackageUrl "${PackageBaseUrl}/dotnet/v3.5.zip?raw=true"
!define Net40PackageUrl "${PackageBaseUrl}/dotnet/v4.0.zip?raw=true"
!define Net452PackageUrl "${PackageBaseUrl}/dotnet/v4.5.2.zip?raw=true"
!define Net461PackageUrl "${PackageBaseUrl}/dotnet/v4.6.1.zip?raw=true"
!define Net472PackageUrl "${PackageBaseUrl}/dotnet/v4.7.2.zip?raw=true"

;*********************************************************************
;*                                                                   *
;*   Include                                                         *
;*                                                                   * 
;*********************************************************************

!include "MUI.nsh"
!include "common.nsh"
!include "x64.nsh"
!include "StrRep.nsh"
!include "ReplaceInFile.nsh"
!include "nsDialogs.nsh"

;*********************************************************************
;*                                                                   *
;*   Variables                                                       *
;*                                                                   * 
;*********************************************************************

Var IsUpdateMode
Var IsUninstall
Var Status
Var InstallCode
Var InstallInsiders
Var InstallNodeJs
Var InstallNet472DevPack
Var InstallTortoise
Var InstallGit
Var InstallDotfuscator
Var InstallNsis
Var InstallPython
Var InstallLegacySdks
Var InstallNetSdks
Var InstallAntAnsicon
Var InstallGradle
Var InstallCompilers

;*********************************************************************
;*                                                                   *
;*   Instructions                                                    *
;*                                                                   * 
;*********************************************************************

; This value is displayed in the lower left of each dialog window
BrandingText " "

; Force CRC checking
CRCCheck force

; This appears in the title bar
Name "${APPLICATION_NAME} ${BUILD_LEVEL} 64-bit"

; The output file name
OutFile "dist\${INSTALL_FILE_NAME}"

; Show details of install
ShowInstDetails show

; Show details of uninstall
ShowUninstDetails show

; Specify the pages to display when performing an Install
Page custom InstTypePageCreate InstTypePageLeave
!define MUI_PAGE_CUSTOMFUNCTION_PRE dirPre
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

; Specify the pages to display when performing an Uninstall
UninstPage custom un.InstTypePageCreate un.InstTypePageLeave
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

; Specify the language
!insertmacro MUI_LANGUAGE "English"


;*********************************************************************
;*                                                                   *
;*   Section Definition                                              *
;*                                                                   *
;*      Install                                                      *
;*                                                                   *
;*********************************************************************

Section "Install"

    SetRegView 64
    SetOutPath "$INSTDIR"
    
    ;
    ; VSCODE BASE (latest/current version)
    ;
    ${If} InstallCode == YES
        MessageBox MB_OKCANCEL "The latest version of Microsoft VS Code will be installed.$\n$\n  \
                By continuing you are agreeing to Microsoft licensing terms." \
                IDOK vscodetrue
            RMDir "$INSTDIR" ; Don't remove if not empty (/r)
            Abort
        vscodetrue:
        ;NSISdl::download ${CodeDownloadUrl} "$INSTDIR\VSCode.exe" ; old built-in method doesnt work
        inetc::get ${CodeDownloadUrl} "$INSTDIR\VSCode.zip"
        ; 'OK' when sucessful
        Pop $Status
        StrCmp $Status "OK" status0_success 0
            RMDir "$INSTDIR" ; Don't remove if not empty (/r)
            Abort
        status0_success:
        ${If} $IsUpdateMode == YES ; remove current code files
            RMDir /r "$INSTDIR\bin"
            RMDir /r "$INSTDIR\locales"
            RMDir /r "$INSTDIR\resources"
            RMDir /r "$INSTDIR\tools"
            Delete "$INSTDIR\*.dll"
            Delete "$INSTDIR\*.pak"
            Delete "$INSTDIR\*.bin"
            Delete "$INSTDIR\Code*"
        ${EndIf}
        ;ExecWait '"$INSTDIR\VSCode.exe" /SILENT /MERGETASKS="!runcode,addcontextmenufiles,addcontextmenufolders,associatewithfiles" /NORESTART /NOCANCEL /SUPPRESSMSGBOXES /DIR="$INSTDIR"'
        nsisunz::Unzip "$INSTDIR\VSCode.zip" "$INSTDIR"
        Pop $Status ; 'success' when sucessful
        Delete "$INSTDIR\VSCode.zip"
        ${If} $IsUpdateMode != YES
            CreateShortCut "$DESKTOP\Code.lnk" "$INSTDIR\code.exe"
            Push "$INSTDIR\bin"
            Call AddToPath
            Push "CODE_HOME"
            Push "$INSTDIR"
            ;Call AddToEnvVar
            Call WriteEnvVar
        ${Endif}
    ${Endif}

    ;
    ; EXTRACT THE INSTALLERS LOCAL FILES - WITHOUT SETTINGS.JSON, PYTHON and TEMP NSIS folder
    ; MAKENSIS.EXE is running from the temp ../build/nsis folder
    ; Only extract settings.json later, after extensions are installed and it doesnt exist already, 
    ; and we are not in update mode
    ; Only extract python dir later, if we are installing/updating it
    ; This would be just the *.bat files, and git.inf, as of 4.18.19
    ;
    File /r /x settings.json /x nsis /x python ..\build\*.*

    ;
    ; NODEJS
    ;
    ${If} $InstallNodeJs == YES
        DetailPrint "Downloading Visual Studio Code..."
        inetc::get ${NodeJsUrl} "$INSTDIR\NodeJs.zip"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status == OK 
            ${If} $IsUpdateMode == YES ; remove current files
                ; Remove global node modules gracefully
                ExecWait '"$INSTDIR\install_node_modules.bat" uninstall'
                RMDir /r "$INSTDIR\nodejs"
            ${EndIf}
            nsisunz::Unzip "$INSTDIR\NodeJs.zip" "$INSTDIR"
            Pop $Status ; 'success' when sucessful
            Delete "$INSTDIR\NodeJs.zip"
            ; INSTALL GLOBAL NODE MODULES
            ExecWait '"$INSTDIR\install_node_modules.bat" install'
            ${If} $IsUpdateMode != YES
                Push "$INSTDIR\nodejs"
                Call AddToPath
                Push "$INSTDIR\nodejs\node_modules\typescript\bin"
                Call AddToPath
            ${Endif}
        ${Else}
            DetailPrint "Error  - $Status"
            DetailPrint "Code installation failure - exit installation"
        ${EndIf}
    ${EndIf}

    ;
    ; VSCODE Insiders (latest/current version)
    ;
    ${If} $InstallInsiders == YES 
        DetailPrint "Downloading Visual Studio Code Insiders..."
        inetc::get ${CodeInsidersDownloadUrl} "$INSTDIR\VSCodeInsiders.zip"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status == OK 
            ;ExecWait '"$INSTDIR\VSCode.exe" /SILENT /MERGETASKS="!runcode,addcontextmenufiles,addcontextmenufolders,associatewithfiles" /NORESTART /NOCANCEL /SUPPRESSMSGBOXES /DIR="$INSTDIR"'
            ${If} $IsUpdateMode == YES ; remove current code insiders files
                RMDir /r "$INSTDIR\insiders"
            ${EndIf}
            CreateDirectory "$INSTDIR\insiders"
            nsisunz::Unzip "$INSTDIR\VSCodeInsiders.zip" "$INSTDIR\insiders"
            Pop $Status ; 'success' when sucessful
            Delete "$INSTDIR\VSCodeInsiders.zip"
            ${If} $IsUpdateMode != YES
                CreateShortCut "$DESKTOP\Code Insiders.lnk" "$INSTDIR\insiders\Code - Insiders.exe"
            ${EndIf}
        ${Else}
            DetailPrint "Error  - $Status"
        ${EndIf}
    ${EndIf}

    ;
    ; .NET 4.72 DEVELOPMENT PACK
    ;
    ${If} $InstallNet472DevPack == YES
        DetailPrint "Downloading .NET 4.72 Developer Pack..."
        inetc::get ${Net472DownloadUrl} "$INSTDIR\NDP472-DevPack.exe"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status == OK 
            ExecWait '"$INSTDIR\NDP472-DevPack.exe" /passive /noreboot'
        ${Else}
            DetailPrint "Error  - $Status"
        ${EndIf}
    ${EndIf}

    ;
    ; GIT
    ;
    ${If} $InstallGit == YES 
        DetailPrint "Downloading Git for Windows..."
        inetc::get ${GitDownloadUrl} "$INSTDIR\GitSetup.exe"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status == OK 
            Push "$INSTDIR\git.inf"     ; copy install dir to inf file
            Push "C:\Program Files\Git" 
            Push "$INSTDIR\git"
            Call ReplaceInFile
            ExecWait '"$INSTDIR\GitSetup.exe" /SILENT /SUPPRESSMSGBOXES /NOCANCEL /NORESTART /SP- /LOADINF="$INSTDIR\git.inf" /DIR="$INSTDIR\git"'
        ${Else}
            DetailPrint "Error  - $Status"
        ${EndIf}
    ${EndIf}
    Delete "$INSTDIR\git.inf"

    ;
    ; TORTOISE SVN
    ;
    ${If} $InstallTortoise == YES
        DetailPrint "Downloading TortoiseSVN..."
        inetc::get ${TortoiseUrl} "$INSTDIR\TortoiseSetup.msi"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status == OK 
            ExecWait 'msiexec /i "$INSTDIR\TortoiseSetup.msi" /passive /norestart INSTALLDIR="$INSTDIR\tortoisesvn" ADDLOCAL=ALL'
        ${Else}
            DetailPrint "Error  - $Status"
        ${EndIf}
    ${EndIf}

    ;
    ; ANT/ANSICON
    ;
    ${If} $InstallAntAnsicon == YES
        DetailPrint "Downloading Apache Ant..."
        inetc::get ${AntUrl} "$INSTDIR\ant.zip"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status == OK 
            ${If} $IsUpdateMode == YES ; remove current files
                RMDir /r "$INSTDIR\ant"
            ${EndIf}
            nsisunz::Unzip "$INSTDIR\ant.zip" "$INSTDIR"
            Pop $Status ; 'success' when sucessful
            Delete "$INSTDIR\ant.zip"
            Push "$INSTDIR\ant\bin"
            ${If} $IsUpdateMode != YES
                Call AddToPath
                Push "ANT_HOME"
                Push "$INSTDIR\ant"
                ;Call AddToEnvVar
                Call WriteEnvVar
            ${Endif}
        ${Else}
            DetailPrint "Error  - $Status"
        ${EndIf}
        DetailPrint "Downloading Ansicon for Ant..."
        inetc::get ${AnsiconUrl} "$INSTDIR\ansicon.zip"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status == OK 
            ${If} $IsUpdateMode == YES ; remove current files
                RMDir /r "$INSTDIR\ansicon"
            ${EndIf}
            nsisunz::Unzip "$INSTDIR\ansicon.zip" "$INSTDIR"
            Pop $Status ; 'success' when sucessful
            Delete "$INSTDIR\ansicon.zip"
            ;${If} $IsUpdateMode != YES
                ;Push "$INSTDIR\ansicon\x64"
                ;Call AddToPath
            ;${Endif}
        ${Else}
            DetailPrint "Error  - $Status"
        ${EndIf}
    ${EndIf}

    ;
    ; GRADLE
    ;
    ${If} $InstallGradle == YES
        DetailPrint "Downloading Gradle Build Tool..."
        inetc::get ${GradleUrl} "$INSTDIR\gradle.zip"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status == OK 
            ${If} $IsUpdateMode == YES ; remove current files
                RMDir /r "$INSTDIR\gradle"
            ${EndIf}
            nsisunz::Unzip "$INSTDIR\gradle.zip" "$INSTDIR"
            Pop $Status ; 'success' when sucessful
            Delete "$INSTDIR\gradle.zip"
            ${If} $IsUpdateMode != YES
                Push "$INSTDIR\gradle\bin"
                Call AddToPath
            ${Endif}
        ${Else}
            DetailPrint "Error  - $Status"
        ${EndIf}
    ${EndIf}

    ;
    ; DOTFUSCATOR CE
    ;
    ${If} $InstallDotfuscator == YES
        DetailPrint "Downloading Dotfuscator Community Edition..."
        inetc::get ${DotfuscatorUrl} "$INSTDIR\DotfuscatorCE.zip"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status == OK 
            ${If} $IsUpdateMode == YES ; remove current files
                RMDir /r "$INSTDIR\dotfuscator\ce"
                RMDir "$INSTDIR\dotfuscator" ; dont remove if another edition is installed here (no /r)
            ${EndIf}
            CreateDirectory "$INSTDIR\dotfuscator"
            nsisunz::Unzip "$INSTDIR\DotfuscatorCE.zip" "$INSTDIR\dotfuscator" ;will extract to 'ce' dir
            Pop $Status ; 'success' when sucessful
            Delete "$INSTDIR\DotfuscatorCE.zip"
        ${Else}
            DetailPrint "Error  - $Status"
        ${EndIf}
    ${EndIf}

    ;
    ; NSIS
    ;
    ${If} $InstallNsis == YES
        DetailPrint "Downloading Nullsoft Scriptable Installer (NSIS)..."
        inetc::get ${NsisUrl} "$INSTDIR\nsis.zip"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status == OK 
            ${If} $IsUpdateMode == YES ; remove current files
                RMDir /r "$INSTDIR\nsis"
            ${EndIf}
            nsisunz::Unzip "$INSTDIR\nsis.zip" "$INSTDIR"
            Pop $Status ; 'success' when sucessful
            Delete "$INSTDIR\nsis.zip"
            ${If} $IsUpdateMode != YES
                Push "$INSTDIR\nsis"
                Call AddToPath
            ${EndIf}
        ${Else}
            DetailPrint "Error  - $Status"
        ${EndIf}
    ${EndIf}

    ;
    ; PYTHON
    ;
    ${If} $InstallPython == YES
        DetailPrint "Downloading Python for Windows..."
        inetc::get ${PythonUrl} "$INSTDIR\python.zip"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status == OK 
            ${If} $IsUpdateMode == YES ; remove current files
                RMDir /r "$INSTDIR\python"
            ${EndIf}
            nsisunz::Unzip "$INSTDIR\python.zip" "$INSTDIR"
            Pop $Status ; 'success' when sucessful
            Delete "$INSTDIR\python.zip"
            ;
            ; PYTHON PIP
            ;
            ; Extract just python local installer dir
            File /r /x *.json /x install_extensions.bat /x install_node_modules.bat /x *.inf /x nsis ..\build\*.*
            Push "$INSTDIR\python\python37._pth" ; replace c:\Code with actual install dir
            Push "c:\Code" 
            Push "$INSTDIR"
            Call ReplaceInFile
            ExecWait '"$INSTDIR\python\install_pip.bat"' ; install pip
            ExecWait '"$INSTDIR\python\install_pylint.bat"' ; install pylint
            Delete "$INSTDIR\python\install_pip.bat"
            Delete "$INSTDIR\python\install_pylint.bat"
            Delete "$INSTDIR\python\python37._pth" ; this was a tmp setup in the installer for setting PATH in this env
            ;Rename "$INSTDIR\python\python37._pth.save" "$INSTDIR\python\python37._pth" ; replace with default file
            ${If} $IsUpdateMode != YES
                Push "$INSTDIR\python"
                Call AddToPath
                Push "$INSTDIR\python\Scripts"
                Call AddToPath
                Push "PYTHONPATH"
                Push "$INSTDIR\python;$INSTDIR\python\DLLs;$INSTDIR\python\lib;$INSTDIR\python\lib\plat-win;$INSTDIR\python\lib\site-packages;$INSTDIR\python\Scripts"
                ;Call AddToEnvVar
                Call WriteEnvVar
            ${Endif}
        ${Else}
            DetailPrint "Error  - $Status"
        ${EndIf}
    ${EndIf}

    ;
    ; Create sdks directory structure if required
    ;
    ${If} $InstallLegacySdks == YES
        CreateDirectory "$INSTDIR\sdks"
        CreateDirectory "$INSTDIR\sdks\windows"
    ${ElseIf} $InstallNetSdks == YES
        CreateDirectory "$INSTDIR\sdks"
    ${EndIf}

    ;
    ; .NET SDK BUNDLES
    ;
    ${If} $InstallNetSdks == YES
        DetailPrint "Downloading .NET SDKs..."
        DetailPrint "Downloading .NET 3.5 Package..."
        inetc::get ${Net35PackageUrl} "$INSTDIR\Net35Package.zip"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status == OK 
            ${If} $IsUpdateMode == YES ; remove current files
                RMDir /r "$INSTDIR\sdks\net35"
            ${EndIf}
            nsisunz::Unzip "$INSTDIR\Net35Package.zip" "$INSTDIR\sdks"
            Pop $Status ; 'success' when sucessful
            Delete "$INSTDIR\Net35Package.zip"
        ${Else}
            DetailPrint "Error  - $Status"
        ${EndIf}
        DetailPrint "Downloading .NET 4 Package..."
        inetc::get ${Net40PackageUrl} "$INSTDIR\Net40Package.zip"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status == OK 
            ${If} $IsUpdateMode == YES ; remove current files
                RMDir /r "$INSTDIR\sdks\net40"
            ${EndIf}
            nsisunz::Unzip "$INSTDIR\Net40Package.zip" "$INSTDIR\sdks"
            Pop $Status ; 'success' when sucessful
            Delete "$INSTDIR\Net40Package.zip"
        ${Else}
            DetailPrint "Error  - $Status"
        ${EndIf}
        DetailPrint "Downloading .NET 4.52 Package..."
        inetc::get ${Net452PackageUrl} "$INSTDIR\Net452Package.zip"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status == OK 
            ${If} $IsUpdateMode == YES ; remove current files
                RMDir /r "$INSTDIR\sdks\net452"
            ${EndIf}
            nsisunz::Unzip "$INSTDIR\Net452Package.zip" "$INSTDIR\sdks"
            Pop $Status ; 'success' when sucessful
            Delete "$INSTDIR\Net452Package.zip"
        ${Else}
            DetailPrint "Error  - $Status"
        ${EndIf}
        DetailPrint "Downloading .NET 4.61 Package..."
        inetc::get ${Net461PackageUrl} "$INSTDIR\Net461Package.zip"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status == OK 
            ${If} $IsUpdateMode == YES ; remove current files
                RMDir /r "$INSTDIR\sdks\net461"
            ${EndIf}
            nsisunz::Unzip "$INSTDIR\Net461Package.zip" "$INSTDIR\sdks"
            Pop $Status ; 'success' when sucessful
            Delete "$INSTDIR\Net461Package.zip"
        ${Else}
            DetailPrint "Error  - $Status"
        ${EndIf}
        DetailPrint "Downloading .NET 4.72 Package..."
        inetc::get ${Net472PackageUrl} "$INSTDIR\Net472Package.zip"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status == OK 
            ${If} $IsUpdateMode == YES ; remove current files
                RMDir /r "$INSTDIR\sdks\net472"
            ${EndIf}
            nsisunz::Unzip "$INSTDIR\Net472Package.zip" "$INSTDIR\sdks"
            Pop $Status ; 'success' when sucessful
            Delete "$INSTDIR\Net472Package.zip"
        ${Else}
            DetailPrint "Error  - $Status"
        ${EndIf}
    ${EndIf}

    ;
    ; LEGACY SDKS
    ;
    ${If} $InstallLegacySdks == YES
        DetailPrint "Downloading Legacy SDK - Wix..."
        inetc::get ${LegacyWixUrl} "$INSTDIR\LegacyWix.zip"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status == OK 
            ${If} $IsUpdateMode == YES ; remove current files
                RMDir /r "$INSTDIR\sdks\wix"
            ${EndIf}
            nsisunz::Unzip "$INSTDIR\LegacyWix.zip" "$INSTDIR\sdks"
            Pop $Status ; 'success' when sucessful
            Delete "$INSTDIR\LegacyWix.zip"
        ${Else}
            DetailPrint "Error  - $Status"
        ${EndIf}
        DetailPrint "Downloading Legacy SDK - AtlMfc..."
        inetc::get ${LegacyAtlMfcUrl} "$INSTDIR\LegacyAtlMfc.zip"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status == OK 
            ${If} $IsUpdateMode == YES ; remove current files
                RMDir /r "$INSTDIR\sdks\atlmfc"
            ${EndIf}
            nsisunz::Unzip "$INSTDIR\LegacyAtlMfc.zip" "$INSTDIR\sdks"
            Pop $Status ; 'success' when sucessful
            Delete "$INSTDIR\LegacyAtlMfc.zip"
        ${Else}
            DetailPrint "Error  - $Status"
        ${EndIf}
        DetailPrint "Downloading Legacy SDK - Windows August 2009..."
        inetc::get ${LegacyWindows2009Url} "$INSTDIR\WindowsAugust2009.zip"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status == OK 
            ${If} $IsUpdateMode == YES ; remove current files
                RMDir /r "$INSTDIR\sdks\windows\august2009"
            ${EndIf}
            nsisunz::Unzip "$INSTDIR\WindowsAugust2009.zip" "$INSTDIR\sdks\windows"
            Pop $Status ; 'success' when sucessful
            Delete "$INSTDIR\WindowsAugust2009.zip"
        ${Else}
            DetailPrint "Error  - $Status"
        ${EndIf}
    ${EndIf}

    ;
    ; EXTENSIONS
    ;
    ${If} $IsUpdateMode != YES ; remove current files
        ExecWait '"$INSTDIR\install_extensions.bat" --install-extension'
    ${EndIf}
    ; Add 'johnstoncode.svn-scm' to enabledProposedApi list in subversion exension, this enabled the file explorer decorations
    ; located in code installation resources/app/product.json
    Push '$INSTDIR\resources\app\product.json'   ; < v 1.32
    Push '"ms-vsliveshare.vsliveshare"]'
    Push '"ms-vsliveshare.vsliveshare", "johnstoncode.svn-scm"]'
    Call ReplaceInFile
    Push '$INSTDIR\resources\app\product.json'   ; >= V 1.32
    Push '"atlassian.atlascode"]'
    Push '"atlassian.atlascode", "johnstoncode.svn-scm"]'
    Call ReplaceInFile

    ;
    ; SETTINGS.JSON
    ;
    ${If} $IsUpdateMode != YES
        ; Check if 'settings.json' exists in the target directory   
        ;IfFileExists "$INSTDIR\data\user-data\User\settings.json" SETTINGS_FILE_ALREADY_EXISTS 0
        IfFileExists "$APPDATA\Code\User\settings.json" settingsexist 0
        ; Copy the file
        ;File /oname=data\user-data\User\settings.json ..\build\settings.json
        CreateDirectory "$APPDATA\Code" ; APPDATA = AppData\Roaming
        CreateDirectory "$APPDATA\Code\User"
        File /oname=$APPDATA\Code\User\settings.json ..\build\settings.json
        ; replace c:\code in settings.json with actual install dir
        ;Push "$INSTDIR\data\user-data\User\settings.json"
        ${If} "$INSTDIR" != "c:\Code"
            Push "$APPDATA\Code\User\settings.json"
            Push "c:\Code" 
            Push "$INSTDIR"
            Call ReplaceInFile
        ${EndIf}
        settingsexist:
    ${EndIf}

    ;
    ; CUSTOM FILES STUFF (eslintrc) run in either install or update modes
    ;
    ExecWait '"$INSTDIR\copy_settings.bat"'
    Delete "$INSTDIR\copy_settings.bat"

    ;
    ; ADD REGISTRY KEYS - VSCODE WINDOWS EXPLORER CONTEXT MENUS
    ;
    ${If} $IsUpdateMode != YES
        WriteRegStr   HKCR "*\shell\Open with VS Code" "" "Edit with VS Code"     
        WriteRegStr   HKCR "*\shell\Open with VS Code" "Icon" "$INSTDIR\Code.exe,0"     
        WriteRegStr   HKCR "*\shell\Open with VS Code\command" "" '"$INSTDIR\Code.exe" "%1"'     
        WriteRegStr   HKCR "Directory\shell\vscode" "" "Open Folder as VS Code Project"     
        WriteRegStr   HKCR "Directory\shell\vscode" "Icon" "$INSTDIR\Code.exe,0"     
        WriteRegStr   HKCR "Directory\shell\vscode\command" "" '"$INSTDIR\Code.exe" "%1"'     
        WriteRegStr   HKCR "Directory\Background\shell\vscode" "" "Open Folder as VS Code Project"     
        WriteRegStr   HKCR "Directory\Background\shell\vscode" "Icon" "$INSTDIR\Code.exe,0"     
        WriteRegStr   HKCR "Directory\Background\shell\vscode\command" "" '"$INSTDIR\Code.exe" "%V"'     
    ${EndIf}

    ;
    ; ADD REGISTRY KEYS - ADD/REMOVE PROGRAMS
    ;
    ${If} $IsUpdateMode != YES
        Strcpy $0 "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPLICATION_NAME}"
        WriteRegStr   HKLM "$0" "DisplayIcon" "$INSTDIR\code.exe"               
        WriteRegStr   HKLM "$0" "DisplayName" "${APPLICATION_NAME}"         
        WriteRegStr   HKLM "$0" "DisplayVersion" "${BUILD_LEVEL}"
        WriteRegDWORD HKLM "$0" "EstimatedSize" 1259000
        WriteRegStr   HKLM "$0" "InstallLocation" "$INSTDIR"
        WriteRegDWORD HKLM "$0" "NoModify" 1
        WriteRegDWORD HKLM "$0" "NoRepair" 1
        WriteRegStr   HKLM "$0" "Publisher" "Scott Meesseman"
        WriteRegStr   HKLM "$0" "UninstallString" "$INSTDIR\${UNINSTALL_FILE_NAME}"
    ${EndIf}

    ; Set context to 'All Users'
    SetShellVarContext "all"

    ;
    ; CREATE UNINSTALLER
    ;
    ${If} $IsUpdateMode != YES
        WriteUninstaller "$INSTDIR\${UNINSTALL_FILE_NAME}"
    ${EndIf}

SectionEnd


;*********************************************************************
;*                                                                   *
;*   Section Definition                                              *
;*                                                                   * 
;*      Uninstall                                                    * 
;*                                                                   * 
;*********************************************************************

Section "Uninstall"

    ;
    ; Explicitly set the registry view to be 64 bits
    ;
    SetRegView 64
    ;
    ; Set context to 'All Users'
    ;
    SetShellVarContext "all"

    ;
    ; CODE
    ;
    ${If} $InstallCode == YES
        ; uninstall vscode
        ; uninstaller for vscode exe installer
        ;ExecWait '"$INSTDIR\unins000.exe" /SILENT /SUPPRESSMSGBOXES'
        ; Extensions
        ExecWait '"$INSTDIR\install_extensions.bat" --uninstall-extension'
        ; Desktop shortcut
        Delete "$DESKTOP\Code.lnk"
        Push "$INSTDIR\bin"
        Call un.RemoveFromPath
        Push "CODE_HOME"
        ;Push "$INSTDIR"
        ;Call un.RemoveFromEnvVar
        Call un.DeleteEnvVar
        DeleteRegKey HKCR "*\shell\Open with VS Code"
        DeleteRegKey HKCR "Directory\shell\vscode"
        DeleteRegKey HKCR "Directory\Background\shell\vscode"
        RMDir /r "$PROFILE\.vscode\extensions"
        RMDir /r "$INSTDIR\bin"
        RMDir /r "$INSTDIR\locales"
        RMDir /r "$INSTDIR\resources"
        RMDir /r "$INSTDIR\tools"
        Delete "$INSTDIR\*.dll"
        Delete "$INSTDIR\*.pak"
        Delete "$INSTDIR\*.bin"
        Delete "$INSTDIR\*.bat"
        Delete "$INSTDIR\Code*"
        MessageBox MB_YESNO "Delete user settings and cache?" IDYES 0 IDNO code1
            ;RMDir /r "$INSTDIR\data"
            RMDir /r "$PROFILE\.vscode"
            RMDir /r "$APPDATA\Code"
        code1:
    ${EndIf}

    ;
    ; CODE INSIDERS
    ;
    ${If} $InstallInsiders == YES 
        RMDir /r "$INSTDIR\insdiers"
        Delete "$DESKTOP\Code Insiders.lnk"
    ${EndIf}

    ;
    ; NODEJS
    ;
    ${If} $InstallNodeJs == YES 
        ExecWait '"$INSTDIR\install_node_modules.bat" uninstall'
        Push "$INSTDIR\nodejs"
        Call un.RemoveFromPath
        Push "$INSTDIR\nodejs\node_modules\typescript\bin"
        Call un.RemoveFromPath
        RMDir /r "$INSTDIR\nodejs"
    ${EndIf}
    
    ;
    ; GIT
    ;
    ${If} $InstallGit == YES 
        ReadRegStr $R0 HKLM "SOFTWARE\GitForWindows" "InstallPath"  ; Check to see if already installed
        IfFileExists "$R0\bin\git.exe" 0 git1
        MessageBox MB_YESNO "Uninstall Git?" IDYES 0 IDNO git1
            ExecWait '"$INSTDIR\git\unins000.exe" /SILENT /SUPPRESSMSGBOXES'
            RMDir /r "$INSTDIR\git"
            Delete "$INSTDIR\GitSetup.exe"
        git1:
    ${EndIf}

    ;
    ; TORTOISESVN
    ;
    ${If} $InstallTortoise == YES 
        ReadRegStr $R0 HKLM "SOFTWARE\TortoiseSVN" "Directory"  ; Check to see if already installed
        IfFileExists "$R0\bin\svn.exe" 0 svn1
        MessageBox MB_YESNO "Uninstall Tortoise SVN?" IDYES 0 IDNO svn1
            ExecWait 'msiexec /x "$INSTDIR\TortoiseSVN-1.11.1.28492-x64-svn-1.11.1.msi" /passive REBOOT=ReallySuppress MSIRESTARTMANAGERCONTROL=Disable'
            RMDir /r "$INSTDIR\tortoisesvn"
            Delete "$INSTDIR\TortoiseSetup.msi"
        svn1:
    ${EndIf}

    ;
    ; .NET472 DEV PACK
    ;
    ${If} $InstallNet472DevPack == YES 
        IfFileExists "$INSTDIR\NDP472-DevPack.exe" 0 net472pack1
            ExecWait '"$INSTDIR\NDP472-DevPack.exe" /uninstall /passive /noreboot'
        net472pack1:
    ${EndIf}

    ;
    ; .NET SDKS
    ;
    ${If} $InstallNetSdks == YES 
        RMDir /r "$INSTDIR\sdks\net35"
        RMDir /r "$INSTDIR\sdks\net40"
        RMDir /r "$INSTDIR\sdks\net452"
        RMDir /r "$INSTDIR\sdks\net461"
        RMDir /r "$INSTDIR\sdks\net472"
    ${EndIf}

    ;
    ; LEGACY SDKS
    ;
    ${If} $InstallLegacySdks == YES 
        RMDir /r "$INSTDIR\sdks\windows"
        RMDir /r "$INSTDIR\sdks\atlmfc"
        RMDir /r "$INSTDIR\sdks\wix"
    ${EndIf}

    ;
    ; ANT
    ;
    ${If} $InstallAntAnsicon == YES 
        Push "$INSTDIR\ant\bin"
        Call un.RemoveFromPath
        Push "ANT_HOME"
        ;Push "$INSTDIR\ant"
        ;Call un.RemoveFromEnvVar
        Call un.DeleteEnvVar
        RMDir /r "$INSTDIR\ant"
        RMDir /r "$INSTDIR\ansicon"
    ${EndIf}

    ;
    ; GRADLE
    ;
    ${If} $InstallGradle == YES 
        Push "$INSTDIR\gradle\bin"
        Call un.RemoveFromPath
        RMDir /r "$INSTDIR\gradle"
    ${EndIf}
    
    ;
    ; COMPILERS PACK
    ;
    ${If} $InstallCompilers == YES 
        RMDir /r "$INSTDIR\compilers"
    ${EndIf}

    ;
    ; DOTFUSCATOR
    ;
    ${If} $InstallDotfuscator == YES 
        RMDir /r "$INSTDIR\dotfuscator"
    ${EndIf}

    ;
    ; NSIS
    ;
    ${If} $InstallNsis == YES 
        Push "$INSTDIR\nsis"
        Call un.RemoveFromPath
        RMDir /r "$INSTDIR\nsis"
    ${EndIf}

    ;
    ; PYTHON
    ;
    
    ${If} $InstallPython == YES 
        Push "$INSTDIR\python"
        Call un.RemoveFromPath
        Push "$INSTDIR\python\scripts"
        Call un.RemoveFromPath
        Push "PYTHONPATH"
        ;Push "$INSTDIR\python;$INSTDIR\python\DLLs;$INSTDIR\python\lib;$INSTDIR\python\lib\plat-win;$INSTDIR\python\lib\site-packages;$INSTDIR\python\Scripts"
        ;Call un.RemoveFromEnvVar
        Call un.DeleteEnvVar
        RMDir /r "$INSTDIR\python"
    ${EndIf}

    ;
    ; DELETE UNINSTALL REGISTRY KEY IF COMPLETE UNINSTALL, REMOVE DIRS FINAL
    ;
    ${If} $InstallCode == YES 
    ${AndIf} $InstallInsiders == YES
    ${AndIf} $InstallNodeJs == YES
    ${AndIf} $InstallAntAnsicon == YES
    ${AndIf} $InstallCompilers == YES
    ${AndIf} $InstallGit == YES
    ${AndIf} $InstallTortoise == YES
    ${AndIf} $InstallGradle == YES
    ${AndIf} $InstallNetSdks == YES
    ${AndIf} $InstallPython == YES
    ${AndIf} $InstallLegacySdks == YES
    ${AndIf} $InstallDotfuscator == YES
    ${AndIf} $InstallNsis == YES
    ${AndIf} $InstallNet472DevPack == YES
        DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPLICATION_NAME}"
        RMDir /r "$INSTDIR\sdks"
        Delete "$INSTDIR\*.bat"
    ${Else}
        ; THIS WILL ONLY REMOVE THE BASE DIR IF IT IS EMPTY (no /r)
        RMDir "$INSTDIR\sdks"
    ${EndIf}

    RMDir "$INSTDIR" 

SectionEnd


;*********************************************************************
;*                                                                   * 
;*      .onInit                                                      * 
;*                                                                   * 
;*********************************************************************

Function .onInit

    ; Specify default directory
    StrCpy $INSTDIR "c:\Code"

    SetRegView 64
    ReadRegStr $R0 HKLM \
    "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPLICATION_NAME}" \
    "InstallLocation"

    StrCmp $R0 "" done

    MessageBox MB_OKCANCEL|MB_ICONEXCLAMATION \
        "${APPLICATION_NAME} is already installed.$\n$\nClick `OK` to \
         select packages to update, or `Cancel` to quit.$\n$\nBefore \ 
         updating,ensure that there are no instances of VSCode running \
         or any of the packages are in use." \
    IDOK update
        Abort
    update:
        StrCpy $IsUpdateMode YES ; Set flag that this is update mode
        ; Copy the current install location, install updates here
        StrCpy $INSTDIR "$R0"
    done:

FunctionEnd

;*********************************************************************
;*                                                                   * 
;*      un.onInit                                                    * 
;*                                                                   * 
;*********************************************************************

Function un.onInit

    StrCpy $IsUninstall YES

FunctionEnd

;*********************************************************************
;*                                                                   * 
;*      dirPre                                                       * 
;*                                                                   * 
;*********************************************************************

Function dirPre
    ${If} $IsUpdateMode == YES ; skip insall dir window if update mode
        Abort
    ${EndIf}
FunctionEnd


;*********************************************************************
;*                                                                   * 
;*      InstTypePageCreate                                           * 
;*                                                                   * 
;*********************************************************************

Function InstTypePageCreate

    nsDialogs::Create 1018
    Pop $1

    !insertmacro MUI_HEADER_TEXT "Visual Studio Code Based Development Environment" \
                                 "Choose Packages to Install" 

    ${If} $InstallCode == ""
        StrCpy $InstallCode YES
    ${EndIf}
    ${If} $InstallInsiders == ""
        StrCpy $InstallInsiders YES
    ${EndIf}
    ${If} $InstallNodeJs == ""
        StrCpy $InstallNodeJs YES
    ${Endif}
    ${If} $InstallNet472DevPack == ""
        StrCpy $InstallNet472DevPack YES
    ${EndIf}
    ${If} $InstallTortoise == ""
        StrCpy $InstallTortoise YES
    ${EndIf}
    ${If} $InstallGit == ""
        StrCpy $InstallGit YES
    ${EndIf}
    ${If} $InstallDotfuscator == ""
        StrCpy $InstallDotfuscator YES
    ${EndIf}
    ${If} $InstallNsis == ""
        StrCpy $InstallNsis YES
    ${EndIf}
    ${If} $InstallPython == ""
        StrCpy $InstallPython YES
    ${EndIf}
    ${If} $InstallNetSdks == ""
        StrCpy $InstallNetSdks YES
    ${EndIf}
    ${If} $InstallLegacySdks == ""
        StrCpy $InstallLegacySdks YES
    ${EndIf}
    ${If} $InstallAntAnsicon == ""
        StrCpy $InstallAntAnsicon YES
    ${EndIf}
    ${If} $InstallGradle == ""
        StrCpy $InstallGradle YES
    ${EndIf}
    ${If} $InstallCompilers == ""
        StrCpy $InstallCompilers YES
    ${EndIf}

    SetRegView 64

    ${NSD_CreateCheckBox} 0 20u 45% 10u "Visual Studio Code"
    Pop $R9
    ${If} $IsUpdateMode != YES
    ${AndIf} $IsUninstall != YES
        EnableWindow $R9 0
        ${NSD_Check} $R9
    ${EndIf}
    ${If} $InstallCode == YES 
        ${NSD_Check} $2
    ${EndIf}

    ${NSD_CreateCheckBox} 0 35u 45% 10u "Visual Studio Code Insiders"
    Pop $2
    IfFileExists "$INSTDIR\insiders\Code - Insiders.exe" 0 insidersdone
        StrCpy $InstallInsiders NO
    insidersdone:
    ${If} $InstallInsiders == YES 
    ${OrIf} $IsUninstall == YES
        ${NSD_Check} $2
    ${EndIf}

    ${NSD_CreateCheckBox} 0 50u 45% 10u "NodeJS and Package Manager (NPM)"
    Pop $R6
    ${If} $IsUpdateMode != YES
    ${AndIf} $IsUninstall != YES
        EnableWindow $R6 0
        ${NSD_Check} $R6
    ${EndIf}
    IfFileExists "$INSTDIR\nodejs\npm.cmd" 0 nodejsdone
        StrCpy $InstallNodeJs NO
    nodejsdone:
    ${If} $InstallNodeJs == YES
    ${OrIf} $IsUninstall == YES
        ${NSD_Check} $R6
    ${EndIf}

    ${NSD_CreateCheckBox} 0 65u 45% 10u "Tortoise SVN + Cmd Line Tools"
    Pop $4
    ReadRegStr $R0 HKLM "SOFTWARE\TortoiseSVN" "Directory"  ; Check to see if already installed
    IfFileExists "$R0\bin\svn.exe" 0 svndone
        EnableWindow $4 0
        StrCpy $InstallTortoise NO
    svndone:
    ${If} $InstallTortoise == YES 
    ${OrIf} $IsUninstall == YES
        ${NSD_Check} $4
    ${EndIf}

    ${NSD_CreateCheckBox} 0 80u 45% 10u "Git for Windows"
    Pop $5
    ReadRegStr $R0 HKLM "SOFTWARE\GitForWindows" "InstallPath"  ; Check to see if already installed
    IfFileExists "$R0\bin\git.exe" 0 gitdone
        EnableWindow $5 0
        StrCpy $InstallGit NO
    gitdone:
    ${If} $InstallGit == YES
    ${OrIf} $IsUninstall == YES 
        ${NSD_Check} $5
    ${EndIf}

    ${NSD_CreateCheckBox} 0 95u 45% 10u "Dotfuscator Community Edition"
    Pop $6
    IfFileExists "$INSTDIR\dotfuscator\ce\DotfuscatorCLI.exe" 0 dotfuscatordone
        StrCpy $InstallDotfuscator NO
    dotfuscatordone:
    ${If} $InstallDotfuscator == YES
    ${OrIf} $IsUninstall == YES 
        ${NSD_Check} $6
    ${EndIf}

    ${NSD_CreateCheckBox} 0 110u 45% 10u "C#/C/C++ Compiler Package"
    Pop $R5
    IfFileExists "$INSTDIR\compilers\c#\15.0\Bin\MSBuild.exe" 0 compilersdone
        StrCpy $InstallCompilers NO
    compilersdone:
    ${If} $InstallCompilers == YES
    ${OrIf} $IsUninstall == YES 
        ${NSD_Check} $R5
    ${EndIf}

    ${NSD_CreateCheckBox} 150u 20u 45% 10u "Apache Ant with Ansicon"
    Pop $R3
    IfFileExists "$INSTDIR\ant\bin\ant.bat" 0 antdone
        StrCpy $InstallAntAnsicon NO
    antdone:
    ${If} $InstallAntAnsicon == YES
    ${OrIf} $IsUninstall == YES 
        ${NSD_Check} $R3
    ${EndIf}

    ${NSD_CreateCheckBox} 150u 35u 45% 10u "Gradle Build Tool"
    Pop $R4
    IfFileExists "$INSTDIR\gradle\bin\gradle.bat" 0 gradledone
        StrCpy $InstallGradle NO
    gradledone:
    ${If} $InstallGradle == YES
    ${OrIf} $IsUninstall == YES 
        ${NSD_Check} $R4
    ${EndIf}

    ${NSD_CreateCheckBox} 150u 50u 45% 10u "Nullsoft Scriptable Installer (NSIS)"
    Pop $7
    IfFileExists "$INSTDIR\nsis\makensis.exe" 0 nsisdone
        StrCpy $InstallNsis NO
    nsisdone:
    ${If} $InstallNsis == YES
    ${OrIf} $IsUninstall == YES 
        ${NSD_Check} $7
    ${EndIf}

    ${NSD_CreateCheckBox} 150u 65u 45% 10u "Python for Windows"
    Pop $8
    IfFileExists "$INSTDIR\python\scripts\pip.exe" 0 pythondone
        StrCpy $InstallPython NO
    pythondone:
    ${If} $InstallPython == YES 
        ${NSD_Check} $8
    ${EndIf}

    ${NSD_CreateCheckBox} 150u 80u 45% 10u ".NET SDKs (3.5, 4.0, 4.52, 4.61, 4.72)"
    Pop $R1
    IfFileExists "$INSTDIR\sdks\atlmfc\lib\atl.lib" 0 netsdksdone
        StrCpy $InstallNetSdks NO
    netsdksdone:
    ${If} $InstallNetSdks == YES
    ${OrIf} $IsUninstall == YES 
        ${NSD_Check} $R1
    ${EndIf}
    
    ${NSD_CreateCheckBox} 150u 95u 45% 10u ".NET 4.72 Developer Pack"
    Pop $3
    IfFileExists "$INSTDIR\NDP472-DevPack.exe" 0 net472done
        StrCpy $InstallNet472DevPack NO
    net472done:
    ${If} $InstallNet472DevPack == YES
    ${OrIf} $IsUninstall == YES 
        ${NSD_Check} $3
    ${EndIf}

    ${NSD_CreateCheckBox} 150u 110u 45% 10u "Legacy SDKs (Atl, Mfc, Windows, Wix)"
    Pop $R2
    IfFileExists "$INSTDIR\sdks\atlmfc\lib\atl.lib" 0 legacysdksdone
        StrCpy $InstallLegacySdks NO
    legacysdksdone:
    ${If} $InstallLegacySdks == YES
    ${OrIf} $IsUninstall == YES 
        ${NSD_Check} $R2
    ${EndIf}

    nsDialogs::Show

FunctionEnd

;*********************************************************************
;*                                                                   * 
;*      InstTypePageCreate                                           * 
;*                                                                   * 
;*********************************************************************

Function un.InstTypePageCreate

    nsDialogs::Create 1018
    Pop $1

    !insertmacro MUI_HEADER_TEXT "Visual Studio Code Based Development Environment" \
                                 "Choose Packages to Install" 

    ${If} $InstallCode == ""
        StrCpy $InstallCode YES
    ${EndIf}
    ${If} $InstallInsiders == ""
        StrCpy $InstallInsiders YES
    ${EndIf}
    ${If} $InstallNodeJs == ""
        StrCpy $InstallNodeJs YES
    ${Endif}
    ${If} $InstallNet472DevPack == ""
        StrCpy $InstallNet472DevPack YES
    ${EndIf}
    ${If} $InstallTortoise == ""
        StrCpy $InstallTortoise YES
    ${EndIf}
    ${If} $InstallGit == ""
        StrCpy $InstallGit YES
    ${EndIf}
    ${If} $InstallDotfuscator == ""
        StrCpy $InstallDotfuscator YES
    ${EndIf}
    ${If} $InstallNsis == ""
        StrCpy $InstallNsis YES
    ${EndIf}
    ${If} $InstallPython == ""
        StrCpy $InstallPython YES
    ${EndIf}
    ${If} $InstallNetSdks == ""
        StrCpy $InstallNetSdks YES
    ${EndIf}
    ${If} $InstallLegacySdks == ""
        StrCpy $InstallLegacySdks YES
    ${EndIf}
    ${If} $InstallAntAnsicon == ""
        StrCpy $InstallAntAnsicon YES
    ${EndIf}
    ${If} $InstallGradle == ""
        StrCpy $InstallGradle YES
    ${EndIf}
    ${If} $InstallCompilers == ""
        StrCpy $InstallCompilers YES
    ${EndIf}

    SetRegView 64

    ${NSD_CreateCheckBox} 0 20u 45% 10u "Visual Studio Code"
    Pop $R9
    ${If} $IsUpdateMode != YES
    ${AndIf} $IsUninstall != YES
        EnableWindow $R9 0
        ${NSD_Check} $R9
    ${EndIf}
    ${If} $InstallCode == YES 
        ${NSD_Check} $2
    ${EndIf}

    ${NSD_CreateCheckBox} 0 35u 45% 10u "Visual Studio Code Insiders"
    Pop $2
    IfFileExists "$INSTDIR\insiders\Code - Insiders.exe" 0 insidersdone
        StrCpy $InstallInsiders NO
    insidersdone:
    ${If} $InstallInsiders == YES 
    ${OrIf} $IsUninstall == YES
        ${NSD_Check} $2
    ${EndIf}

    ${NSD_CreateCheckBox} 0 50u 45% 10u "NodeJS and Package Manager (NPM)"
    Pop $R6
    ${If} $IsUpdateMode != YES
    ${AndIf} $IsUninstall != YES
        EnableWindow $R6 0
        ${NSD_Check} $R6
    ${EndIf}
    IfFileExists "$INSTDIR\nodejs\npm.cmd" 0 nodejsdone
        StrCpy $InstallNodeJs NO
    nodejsdone:
    ${If} $InstallNodeJs == YES
    ${OrIf} $IsUninstall == YES
        ${NSD_Check} $R6
    ${EndIf}

    ${NSD_CreateCheckBox} 0 65u 45% 10u "Tortoise SVN + Cmd Line Tools"
    Pop $4
    ReadRegStr $R0 HKLM "SOFTWARE\TortoiseSVN" "Directory"  ; Check to see if already installed
    IfFileExists "$R0\bin\svn.exe" 0 svndone
        EnableWindow $4 0
        StrCpy $InstallTortoise NO
    svndone:
    ${If} $InstallTortoise == YES 
    ${OrIf} $IsUninstall == YES
        ${NSD_Check} $4
    ${EndIf}

    ${NSD_CreateCheckBox} 0 80u 45% 10u "Git for Windows"
    Pop $5
    ReadRegStr $R0 HKLM "SOFTWARE\GitForWindows" "InstallPath"  ; Check to see if already installed
    IfFileExists "$R0\bin\git.exe" 0 gitdone
        EnableWindow $5 0
        StrCpy $InstallGit NO
    gitdone:
    ${If} $InstallGit == YES
    ${OrIf} $IsUninstall == YES 
        ${NSD_Check} $5
    ${EndIf}

    ${NSD_CreateCheckBox} 0 95u 45% 10u "Dotfuscator Community Edition"
    Pop $6
    IfFileExists "$INSTDIR\dotfuscator\ce\DotfuscatorCLI.exe" 0 dotfuscatordone
        StrCpy $InstallDotfuscator NO
    dotfuscatordone:
    ${If} $InstallDotfuscator == YES
    ${OrIf} $IsUninstall == YES 
        ${NSD_Check} $6
    ${EndIf}

    ${NSD_CreateCheckBox} 0 110u 45% 10u "C#/C/C++ Compiler Package"
    Pop $R5
    IfFileExists "$INSTDIR\compilers\c#\15.0\Bin\MSBuild.exe" 0 compilersdone
        StrCpy $InstallCompilers NO
    compilersdone:
    ${If} $InstallCompilers == YES
    ${OrIf} $IsUninstall == YES 
        ${NSD_Check} $R5
    ${EndIf}

    ${NSD_CreateCheckBox} 150u 20u 45% 10u "Apache Ant with Ansicon"
    Pop $R3
    IfFileExists "$INSTDIR\ant\bin\ant.bat" 0 antdone
        StrCpy $InstallAntAnsicon NO
    antdone:
    ${If} $InstallAntAnsicon == YES
    ${OrIf} $IsUninstall == YES 
        ${NSD_Check} $R3
    ${EndIf}

    ${NSD_CreateCheckBox} 150u 35u 45% 10u "Gradle Build Tool"
    Pop $R4
    IfFileExists "$INSTDIR\gradle\bin\gradle.bat" 0 gradledone
        StrCpy $InstallGradle NO
    gradledone:
    ${If} $InstallGradle == YES
    ${OrIf} $IsUninstall == YES 
        ${NSD_Check} $R4
    ${EndIf}

    ${NSD_CreateCheckBox} 150u 50u 45% 10u "Nullsoft Scriptable Installer (NSIS)"
    Pop $7
    IfFileExists "$INSTDIR\nsis\makensis.exe" 0 nsisdone
        StrCpy $InstallNsis NO
    nsisdone:
    ${If} $InstallNsis == YES
    ${OrIf} $IsUninstall == YES 
        ${NSD_Check} $7
    ${EndIf}

    ${NSD_CreateCheckBox} 150u 65u 45% 10u "Python for Windows"
    Pop $8
    IfFileExists "$INSTDIR\python\scripts\pip.exe" 0 pythondone
        StrCpy $InstallPython NO
    pythondone:
    ${If} $InstallPython == YES 
        ${NSD_Check} $8
    ${EndIf}

    ${NSD_CreateCheckBox} 150u 80u 45% 10u ".NET SDKs (3.5, 4.0, 4.52, 4.61, 4.72)"
    Pop $R1
    IfFileExists "$INSTDIR\sdks\atlmfc\lib\atl.lib" 0 netsdksdone
        StrCpy $InstallNetSdks NO
    netsdksdone:
    ${If} $InstallNetSdks == YES
    ${OrIf} $IsUninstall == YES 
        ${NSD_Check} $R1
    ${EndIf}
    
    ${NSD_CreateCheckBox} 150u 95u 45% 10u ".NET 4.72 Developer Pack"
    Pop $3
    IfFileExists "$INSTDIR\NDP472-DevPack.exe" 0 net472done
        StrCpy $InstallNet472DevPack NO
    net472done:
    ${If} $InstallNet472DevPack == YES
    ${OrIf} $IsUninstall == YES 
        ${NSD_Check} $3
    ${EndIf}

    ${NSD_CreateCheckBox} 150u 110u 45% 10u "Legacy SDKs (Atl, Mfc, Windows, Wix)"
    Pop $R2
    IfFileExists "$INSTDIR\sdks\atlmfc\lib\atl.lib" 0 legacysdksdone
        StrCpy $InstallLegacySdks NO
    legacysdksdone:
    ${If} $InstallLegacySdks == YES
    ${OrIf} $IsUninstall == YES 
        ${NSD_Check} $R2
    ${EndIf}

    nsDialogs::Show

FunctionEnd

;*********************************************************************
;*                                                                   *
;*   Function Definition                                             *
;*                                                                   * 
;*      InstTypePageLeave                                            * 
;*                                                                   * 
;*********************************************************************

Function InstTypePageLeave

    ${NSD_GetState} $R9 $0
    ${If} $0 != ${BST_CHECKED}
        StrCpy $InstallCode NO
    ${Else}
        StrCpy $InstallCode YES
    ${EndIf}

    ${NSD_GetState} $2 $0
    ${If} $0 != ${BST_CHECKED}
        StrCpy $InstallInsiders NO
    ${Else}
        StrCpy $InstallInsiders YES
    ${EndIf}

    ${NSD_GetState} $R6 $0
    ${If} $0 != ${BST_CHECKED}
        StrCpy $InstallNodeJs NO
    ${Else}
        StrCpy $InstallNodeJs YES
    ${EndIf}

    ${NSD_GetState} $3 $0
    ${If} $0 != ${BST_CHECKED}
        StrCpy $InstallNet472DevPack NO
    ${Else}
        StrCpy $InstallNet472DevPack YES
    ${EndIf}

    ${NSD_GetState} $4 $0
    ${If} $0 != ${BST_CHECKED}
        StrCpy $InstallTortoise NO
    ${Else}
        StrCpy $InstallTortoise YES
    ${EndIf}

    ${NSD_GetState} $5 $0
    ${If} $0 != ${BST_CHECKED}
        StrCpy $InstallGit NO
    ${Else}
        StrCpy $InstallGit YES
    ${EndIf}

    ${NSD_GetState} $6 $0
    ${If} $0 != ${BST_CHECKED}
        StrCpy $InstallDotfuscator NO
    ${Else}
        StrCpy $InstallDotfuscator YES
    ${EndIf}

    ${NSD_GetState} $7 $0
    ${If} $0 != ${BST_CHECKED}
        StrCpy $InstallNsis NO
    ${Else}
        StrCpy $InstallNsis YES
    ${EndIf}

    ${NSD_GetState} $8 $0
    ${If} $0 != ${BST_CHECKED}
        StrCpy $InstallPython NO
    ${Else}
        StrCpy $InstallPython YES
    ${EndIf}

    ${NSD_GetState} $R1 $0
    ${If} $0 != ${BST_CHECKED}
        StrCpy $InstallNetSdks NO
    ${Else}
        StrCpy $InstallNetSdks YES
    ${EndIf}

    ${NSD_GetState} $R2 $0
    ${If} $0 != ${BST_CHECKED}
        StrCpy $InstallLegacySdks NO
    ${Else}
        StrCpy $InstallLegacySdks YES
    ${EndIf}

    ${NSD_GetState} $R3 $0
    ${If} $0 != ${BST_CHECKED}
        StrCpy $InstallAntAnsicon NO
    ${Else}
        StrCpy $InstallAntAnsicon YES
    ${EndIf}

    ${NSD_GetState} $R4 $0
    ${If} $0 != ${BST_CHECKED}
        StrCpy $InstallGradle NO
    ${Else}
        StrCpy $InstallGradle YES
    ${EndIf}

    ${NSD_GetState} $R5 $0
    ${If} $0 != ${BST_CHECKED}
        StrCpy $InstallCompilers NO
    ${Else}
        StrCpy $InstallCompilers YES
    ${EndIf}

    ${If} $InstallCode == NO 
    ${AndIf} $InstallInsiders == NO
    ${AndIf} $InstallNodeJs == NO
    ${AndIf} $InstallAntAnsicon == NO
    ${AndIf} $InstallCompilers == NO
    ${AndIf} $InstallGit == NO
    ${AndIf} $InstallTortoise == NO
    ${AndIf} $InstallGradle == NO
    ${AndIf} $InstallNetSdks == NO
    ${AndIf} $InstallPython == NO
    ${AndIf} $InstallLegacySdks == NO
    ${AndIf} $InstallDotfuscator == NO
    ${AndIf} $InstallNsis == NO
    ${AndIf} $InstallNet472DevPack == NO
        MessageBox MB_OK|MB_ICONEXCLAMATION        \
            "You must select at least one package to update" \
        IDOK 0
            Abort
    ${Endif}

FunctionEnd

;*********************************************************************
;*                                                                   *
;*   Function Definition                                             *
;*                                                                   * 
;*      un.InstTypePageLeave                                         * 
;*                                                                   * 
;*********************************************************************

Function un.InstTypePageLeave
    
    ${NSD_GetState} $R9 $0
    ${If} $0 != ${BST_CHECKED}
        StrCpy $InstallCode NO
    ${Else}
        StrCpy $InstallCode YES
    ${EndIf}

    ${NSD_GetState} $2 $0
    ${If} $0 != ${BST_CHECKED}
        StrCpy $InstallInsiders NO
    ${Else}
        StrCpy $InstallInsiders YES
    ${EndIf}

    ${NSD_GetState} $R6 $0
    ${If} $0 != ${BST_CHECKED}
        StrCpy $InstallNodeJs NO
    ${Else}
        StrCpy $InstallNodeJs YES
    ${EndIf}

    ${NSD_GetState} $3 $0
    ${If} $0 != ${BST_CHECKED}
        StrCpy $InstallNet472DevPack NO
    ${Else}
        StrCpy $InstallNet472DevPack YES
    ${EndIf}

    ${NSD_GetState} $4 $0
    ${If} $0 != ${BST_CHECKED}
        StrCpy $InstallTortoise NO
    ${Else}
        StrCpy $InstallTortoise YES
    ${EndIf}

    ${NSD_GetState} $5 $0
    ${If} $0 != ${BST_CHECKED}
        StrCpy $InstallGit NO
    ${Else}
        StrCpy $InstallGit YES
    ${EndIf}

    ${NSD_GetState} $6 $0
    ${If} $0 != ${BST_CHECKED}
        StrCpy $InstallDotfuscator NO
    ${Else}
        StrCpy $InstallDotfuscator YES
    ${EndIf}

    ${NSD_GetState} $7 $0
    ${If} $0 != ${BST_CHECKED}
        StrCpy $InstallNsis NO
    ${Else}
        StrCpy $InstallNsis YES
    ${EndIf}

    ${NSD_GetState} $8 $0
    ${If} $0 != ${BST_CHECKED}
        StrCpy $InstallPython NO
    ${Else}
        StrCpy $InstallPython YES
    ${EndIf}

    ${NSD_GetState} $R1 $0
    ${If} $0 != ${BST_CHECKED}
        StrCpy $InstallNetSdks NO
    ${Else}
        StrCpy $InstallNetSdks YES
    ${EndIf}

    ${NSD_GetState} $R2 $0
    ${If} $0 != ${BST_CHECKED}
        StrCpy $InstallLegacySdks NO
    ${Else}
        StrCpy $InstallLegacySdks YES
    ${EndIf}

    ${NSD_GetState} $R3 $0
    ${If} $0 != ${BST_CHECKED}
        StrCpy $InstallAntAnsicon NO
    ${Else}
        StrCpy $InstallAntAnsicon YES
    ${EndIf}

    ${NSD_GetState} $R4 $0
    ${If} $0 != ${BST_CHECKED}
        StrCpy $InstallGradle NO
    ${Else}
        StrCpy $InstallGradle YES
    ${EndIf}

    ${NSD_GetState} $R5 $0
    ${If} $0 != ${BST_CHECKED}
        StrCpy $InstallCompilers NO
    ${Else}
        StrCpy $InstallCompilers YES
    ${EndIf}

    ${If} $InstallCode == NO 
    ${AndIf} $InstallInsiders == NO
    ${AndIf} $InstallNodeJs == NO
    ${AndIf} $InstallAntAnsicon == NO
    ${AndIf} $InstallCompilers == NO
    ${AndIf} $InstallGit == NO
    ${AndIf} $InstallTortoise == NO
    ${AndIf} $InstallGradle == NO
    ${AndIf} $InstallNetSdks == NO
    ${AndIf} $InstallPython == NO
    ${AndIf} $InstallLegacySdks == NO
    ${AndIf} $InstallDotfuscator == NO
    ${AndIf} $InstallNsis == NO
    ${AndIf} $InstallNet472DevPack == NO
        MessageBox MB_OK|MB_ICONEXCLAMATION        \
            "You must select at least one package to update" \
        IDOK 0
            Abort
    ${Endif}

FunctionEnd
