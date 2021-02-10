
;*********************************************************************
;*                                                                   *
;*   Define                                                          *
;*                                                                   * 
;*********************************************************************

; Define application name
!define APPLICATION_NAME     "Code Package"

; Define build level
!define BUILD_LEVEL          "2.6.1"

; Define install file name
!define INSTALL_FILE_NAME    "code-package-x64.exe"

; Define uninstall file name
!define UNINSTALL_FILE_NAME  "code-package-uninst.exe"

; Define MUI_ABORTWARNING so that a warning message is displayed
; if you attempt to cancel an install
!define MUI_ABORTWARNING

; Define MUI_HEADERPAGE to display a custom bitmap
!define MUI_ICON "code.ico"
!define MUI_HEADERIMAGE 
!define MUI_HEADERIMAGE_BITMAP "installerhdr.bmp"

; Set context to 'All Users'
!define ALL_USERS

; Public URLs
!define CodeDownloadUrl "https://update.code.visualstudio.com/latest/win32-x64-archive/stable"
!define CodeInsidersDownloadUrl "https://update.code.visualstudio.com/latest/win32-x64-archive/insider"
!define GitDownloadUrl "https://github.com/git-for-windows/git/releases/download/v2.23.0.windows.1/Git-2.23.0-64-bit.exe"
!define NugetCliUrl "https://dist.nuget.org/win-x86-commandline/v4.9.4/nuget.exe"
!define Net472DownloadUrl "https://go.microsoft.com/fwlink/?LinkId=874338"
!define CygwinDownloadUrl "https://www.cygwin.com/setup-x86_64.exe"
; Private URLs (requires manual auth/url, for registered ce users only)
!define DotfuscatorUrl "http://app1.spmeesseman.com/download/code-package/dotfuscator-ce.zip" ; will throw 404
; Repo URLs
!define PackageBaseUrl "https://github.com/spmeesseman/code-package/blob/master/src"
!define TortoiseUrl "${PackageBaseUrl}/tortoisesvn/tortoisesvn.msi?raw=true"
!define NodeJsUrl "${PackageBaseUrl}/nodejs/nodejs.zip?raw=true"
!define NsisUrl "${PackageBaseUrl}/nsis/nsis.zip?raw=true"
!define PhpUrl "${PackageBaseUrl}/php/php.zip?raw=true"
!define NotepadUrl "${PackageBaseUrl}/notepad++/npp.zip?raw=true"
!define PythonUrl "${PackageBaseUrl}/python/python.zip?raw=true"
!define AntUrl "${PackageBaseUrl}/ant/ant.zip?raw=true"
!define AnsiconUrl "${PackageBaseUrl}/ansicon/ansicon.zip?raw=true"
!define GradleUrl "${PackageBaseUrl}/gradle/gradle.zip?raw=true"
!define CompilerCCPlusPlus9Url "${PackageBaseUrl}/compilers/C_C%2B%2B/9.0.zip?raw=true"
!define CompilerCSharp8Url "${PackageBaseUrl}/compilers/C%23/8.0.zip?raw=true"
!define CompilerCSharp15Url "${PackageBaseUrl}/compilers/C%23/15.0.zip?raw=true"
!define CompilerCSharp16Url "${PackageBaseUrl}/compilers/C%23/vs_16_buildtools.exe?raw=true"
!define LegacyWixUrl "${PackageBaseUrl}/sdks/wix.zip?raw=true"
!define LegacyAtlMfcUrl "${PackageBaseUrl}/sdks/atlmfc.zip?raw=true"
!define LegacyWindows2009Url "${PackageBaseUrl}/sdks/windows/august2009.zip?raw=true"
!define DotNetPackageUrl "${PackageBaseUrl}/dotnet/dotnet.zip?raw=true"

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
!include "ExecWaitJob.nsh"

;*********************************************************************
;*                                                                   *
;*   Variables                                                       *
;*                                                                   * 
;*********************************************************************

Var IsUpdateMode
Var Status
Var InstallCode
Var InstallInsiders
Var InstallNodeJs
Var InstallNet472DevPack
Var InstallTortoise
Var InstallGit
Var InstallDotfuscator
Var InstallNsis
Var InstallPhp
Var InstallNotepad
Var InstallCygwin
Var InstallPython
Var InstallLegacySdks
Var InstallNetSdks
Var InstallAntAnsicon
Var InstallGradle
Var InstallCompilers
Var InstallsSaved
Var DotfuscatorUrlVar
;var /GLOBAL WithOption

;*********************************************************************
;*                                                                   *
;*   Instructions                                                    *
;*                                                                   * 
;*********************************************************************

; This value is displayed in the lower left of each dialog window
BrandingText " "

;ComponentText "Select the components you want to install."

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
Page custom InstAuthPageCreate InstAuthPageLeave
;!insertmacro MUI_PAGE_COMPONENTS
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
    ; EXTRACT THE INSTALLERS LOCAL FILES - WITHOUT SETTINGS.JSON, PYTHON and TEMP NSIS folder
    ; MAKENSIS.EXE is running from the temp ../build/nsis folder
    ; Only extract settings.json later, after extensions are installed and it doesnt exist already, 
    ; and we are not in update mode
    ; Only extract python dir later, if we are installing/updating it
    ; This would be just the *.bat files, and git.inf, as of 4.18.19
    ;
    File /r /x settings.json /x nsis /x python ..\build\*.*

    ;
    ; VSCODE BASE (latest/current version)
    ;
    ${If} $InstallCode == YES
        MessageBox MB_OKCANCEL "The latest version of Microsoft VS Code will be installed.$\n$\n  \
                By continuing you are agreeing to Microsoft licensing terms." \
                IDOK vscodetrue
            RMDir "$INSTDIR" ; Don't remove if not empty (/r)
            DetailPrint "Code installation cancelled by user - exit installation"
            Abort
        vscodetrue:
        DetailPrint "Downloading Visual Studio Code..."
        ;NSISdl::download ${CodeDownloadUrl} "$INSTDIR\VSCode.exe" ; old built-in method doesnt work
        inetc::get ${CodeDownloadUrl} "$INSTDIR\VSCode.zip"
        ; 'OK' when sucessful
        Pop $Status
        StrCmp $Status "OK" status0_success 0
            RMDir "$INSTDIR" ; Don't remove if not empty (/r)
            DetailPrint "Code installation failure on download - exit installation"
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
            Delete "$INSTDIR\Code.*"
        ${EndIf}
        CreateDirectory "$INSTDIR\data"
        CreateDirectory "$INSTDIR\data\extensions"
        ;ExecWait '"$INSTDIR\VSCode.exe" /SILENT /MERGETASKS="!runcode,addcontextmenufiles,addcontextmenufolders,associatewithfiles" /NORESTART /NOCANCEL /SUPPRESSMSGBOXES /DIR="$INSTDIR"'
        DetailPrint "Unpacking Visual Studio Code..."
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
        ; Removed 6/26/19 - as of v 1.35, extension will prompt user and do this itself
        ;${If} $IsUpdateMode != YES
        ;    ; Add 'johnstoncode.svn-scm' to enabledProposedApi list in subversion exension, this enabled the file explorer decorations
        ;    ; located in code installation resources/app/product.json
        ;    Push '$INSTDIR\resources\app\product.json'   ; < v 1.32
        ;    Push '"ms-vsliveshare.vsliveshare"]'
        ;    Push '"ms-vsliveshare.vsliveshare", "johnstoncode.svn-scm"]'
        ;    Call ReplaceInFile
        ;    Push '$INSTDIR\resources\app\product.json'   ; >= V 1.32
        ;    Push '"atlassian.atlascode"]'
        ;    Push '"atlassian.atlascode", "johnstoncode.svn-scm"]'
        ;    Call ReplaceInFile
        ;${Endif}
        ${IfNot} ${FileExists} "$INSTDIR\data\extensions\spmeesseman.vscode-taskexplorer\extension.js"
            ; Install extensions
            ExecWait '"$INSTDIR\install_extensions.bat" --install-extension code'
        ${EndIf}
        ; SETTINGS.JSON
        ; Check if 'settings.json' exists in the target directory   
        IfFileExists "$INSTDIR\data\user-data\User\settings.json" settingsexist 0
        ;IfFileExists "$APPDATA\Code\User\settings.json" settingsexist 0
        ; Copy the file
        File /oname=data\user-data\User\settings.json ..\build\settings.json
        ;CreateDirectory "$APPDATA\Code" ; APPDATA = AppData\Roaming
        ;CreateDirectory "$APPDATA\Code\User"
        ;File /oname=$APPDATA\Code\User\settings.json ..\build\settings.json
        ; replace c:\code in settings.json with actual install dir
        ${If} "$INSTDIR" != "c:\Code"
            ;Push "$APPDATA\Code\User\settings.json"
            Push "$INSTDIR\data\user-data\User\settings.json"
            Push "c:\Code" 
            Push "$INSTDIR"
            Call ReplaceInFile
        ${EndIf}
        settingsexist:
    ${Endif}

    ;
    ; VSCODE Insiders (latest/current version)
    ;
    ${If} $InstallInsiders == YES 
        MessageBox MB_OKCANCEL "The latest version of Microsoft VS Code Insiders will be installed.$\n$\n  \
                By continuing you are agreeing to Microsoft licensing terms." \
                IDOK vscode2true
            RMDir "$INSTDIR" ; Don't remove if not empty (/r)
            DetailPrint "Code Insiders installation cancelled by user - exit installation"
            Abort
        vscode2true:
        DetailPrint "Downloading Visual Studio Code Insiders..."
        inetc::get ${CodeInsidersDownloadUrl} "$INSTDIR\VSCodeInsiders.zip"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status == OK 
            ;ExecWait '"$INSTDIR\VSCode.exe" /SILENT /MERGETASKS="!runcode,addcontextmenufiles,addcontextmenufolders,associatewithfiles" /NORESTART /NOCANCEL /SUPPRESSMSGBOXES /DIR="$INSTDIR"'
            CreateDirectory "$INSTDIR\insiders"
	        ${If} $IsUpdateMode == YES ; remove current code files
                RMDir /r "$INSTDIR\insiders\bin"
                RMDir /r "$INSTDIR\insiders\locales"
                RMDir /r "$INSTDIR\insiders\resources"
                RMDir /r "$INSTDIR\insiders\tools"
                Delete "$INSTDIR\insiders\*.dll"
                Delete "$INSTDIR\insiders\*.pak"
                Delete "$INSTDIR\insiders\*.bin"
                Delete "$INSTDIR\insiders\Code - Insiders.*"
            ${EndIf}
            CreateDirectory "$INSTDIR\insiders\data"
            CreateDirectory "$INSTDIR\insiders\data\extensions"
            DetailPrint "Unpacking Visual Studio Code Insiders..."
            nsisunz::Unzip "$INSTDIR\VSCodeInsiders.zip" "$INSTDIR\insiders"
            Pop $Status ; 'success' when sucessful
            Delete "$INSTDIR\VSCodeInsiders.zip"
            ${If} $IsUpdateMode != YES
                CreateShortCut "$DESKTOP\Code Insiders.lnk" "$INSTDIR\insiders\Code - Insiders.exe"
            ${EndIf}
            ${If} $IsUpdateMode != YES
                CreateShortCut "$DESKTOP\Code Insiders.lnk" "$INSTDIR\insiders\Code - Insiders.exe"
                Push "$INSTDIR\insiders\bin"
                Call AddToPath
                Push "CODE_INSIDERS_HOME"
                Push "$INSTDIR\insiders"
                ;Call AddToEnvVar
                Call WriteEnvVar
            ${Endif}
        ${Else}
            DetailPrint "Error  - $Status"
        ${EndIf}
        ;${If} $IsUpdateMode != YES
        ;    ; Add 'johnstoncode.svn-scm' to enabledProposedApi list in subversion exension, this enabled the file explorer decorations
        ;    ; located in code installation resources/app/product.json
        ;    Push '$INSTDIR\insiders\resources\app\product.json'   ; >= V 1.33
        ;    Push '"ms-vscode.vscode-remote-extensionpack"]'
        ;    Push '"ms-vscode.vscode-remote-extensionpack", "johnstoncode.svn-scm"]'
        ;    Call ReplaceInFile
        ;${Endif}
        ${IfNot} ${FileExists} "$INSTDIR\data\extensions\spmeesseman.vscode-taskexplorer\extension.js"
            ; Install extensions
            File "/oname=$INSTDIR\insiders\install_extensions.bat" ..\build\install_extensions.bat
            ExecWait '"$INSTDIR\insiders\install_extensions.bat" --install-extension code-insiders'
        ${EndIf}
        ; SETTINGS.JSON
        ; Check if 'settings.json' exists in the target directory   
        IfFileExists "$INSTDIR\insiders\data\user-data\User\settings.json" settingsexist2 0
        ;IfFileExists "$APPDATA\Code\User\settings.json" settingsexist2 0
        ; Copy the file
        File /oname=data\user-data\User\settings.json ..\build\settings.json
        ;CreateDirectory "$APPDATA\Code - Insiders" ; APPDATA = AppData\Roaming
        ;CreateDirectory "$APPDATA\Code - Insiders\User"
        ;File /oname=$APPDATA\Code - Insiders\User\settings.json ..\build\settings.json
        ; replace c:\code in settings.json with actual install dir
        ${If} "$INSTDIR" != "c:\Code"
            ;Push "$APPDATA\Code\User\settings.json"
            Push "$INSTDIR\insiders\data\user-data\User\settings.json"
            Push "c:\Code" 
            Push "$INSTDIR\insiders"
            Call ReplaceInFile
        ${EndIf}
        settingsexist2:
    ${EndIf}

    ;
    ; NODEJS
    ;
    ${If} $InstallNodeJs == YES
        DetailPrint "Downloading NodeJS and NPM..."
        inetc::get ${NodeJsUrl} "$INSTDIR\NodeJs.zip"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status == OK 
            ${If} $IsUpdateMode == YES ; remove current files
                ; Remove global node modules gracefully
                ExecWait '"$INSTDIR\install_node_modules.bat" uninstall'
                RMDir /r "$INSTDIR\nodejs"
            ${EndIf}
            DetailPrint "Unpacking NodeJS and NPM..."
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
    ; CYGWIN
    ;
    ${If} $InstallCygwin == YES
        DetailPrint "Downloading Cygwin for Windows Setup..."
        inetc::get ${CygwinDownloadUrl} "$INSTDIR\cygwin-setup.exe"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status == OK 
            ExecWait '$INSTDIR\cygwin-setup.exe --quiet-mode --upgrade-also --delete-orphans --disable-buggy-antivirus \
                     --root "$INSTDIR\cygwin64" --site http://cygwin.mirror.constant.com --verbose \
                     --local-package-dir "$INSTDIR\cygwin64\downloads" --arch x64 \
                     --packages "gcc-core,gcc-g++,make,automake,autoconf,readline,libncursesw-devel,libiconv,zlib-devel,gettext,\
                       apache2-devel,libtool,git,curl,jq,libcurl,openssh,cygrunsrv,more,grep,stat,cygpath" --prune-install'
            ${If} $IsUpdateMode != YES
                Push "$INSTDIR\cygwin64\bin"
                Call AddToPath
            ${Endif}
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
            DetailPrint "Unpacking Apache Ant..."
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
            DetailPrint "Unpacking Ansicon for Ant..."
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
            DetailPrint "Unpacking Gradle Build Tool..."
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
    ${AndIf} $DotfuscatorUrlVar != ""
    ${AndIf} $DotfuscatorUrlVar != "http://"
    ${AndIf} $DotfuscatorUrlVar != "https://"
        DetailPrint "Downloading Dotfuscator Community Edition..."
        inetc::get $DotfuscatorUrlVar "$INSTDIR\DotfuscatorCE.zip"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status == OK 
            ${If} $IsUpdateMode == YES ; remove current files
                RMDir /r "$INSTDIR\dotfuscator\ce"
                RMDir "$INSTDIR\dotfuscator" ; dont remove if another edition is installed here (no /r)
            ${EndIf}
            CreateDirectory "$INSTDIR\dotfuscator"
            DetailPrint "Unpacking Dotfuscator CE..."
            nsisunz::Unzip "$INSTDIR\DotfuscatorCE.zip" "$INSTDIR\dotfuscator" ;will extract to 'ce' dir
            Pop $Status ; 'success' when sucessful
            Delete "$INSTDIR\DotfuscatorCE.zip"
        ${Else}
            DetailPrint "Error  - $Status"
        ${EndIf}
    ${ElseIf} $InstallDotfuscator == YES
        DetailPrint "Downloading Dotfuscator Community Edition..."
        DetailPrint "Error  - Manual URL entry for registered Dofuscator download required"
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
            DetailPrint "Unpacking Nullsoft Scriptable Installer (NSIS)..."
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
    ; PHP
    ;
    ${If} $InstallPhp == YES
        DetailPrint "Downloading PHP for Windows..."
        inetc::get ${PhpUrl} "$INSTDIR\php.zip"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status == OK 
            ${If} $IsUpdateMode == YES ; remove current files
                RMDir /r "$INSTDIR\php"
            ${EndIf}
            DetailPrint "Unpacking PHP for Windows..."
            nsisunz::Unzip "$INSTDIR\php.zip" "$INSTDIR"
            Pop $Status ; 'success' when sucessful
            Delete "$INSTDIR\php.zip"
            ${If} $IsUpdateMode != YES
                Push "$INSTDIR\php"
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
            DetailPrint "Unpacking Python for Windows..."
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
    ; COMPILERS
    ;
    ${If} $InstallCompilers == YES
        CreateDirectory "$INSTDIR\compilers"
        DetailPrint "Downloading C/C++ Compiler 9.0 Package..."
        inetc::get ${CompilerCCPlusPlus9Url} "$INSTDIR\CCPlusPlus9.zip"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status == OK 
            ${If} $IsUpdateMode == YES ; remove current files
                RMDir /r "$INSTDIR\compilers\c_c++\9.0"
            ${EndIf}
            CreateDirectory "$INSTDIR\compilers\c_c++"
            DetailPrint "Unpacking C/C++ Compiler 9.0 Package..."
            nsisunz::Unzip "$INSTDIR\CCPlusPlus9.zip" "$INSTDIR\compilers\c_c++"
            Pop $Status ; 'success' when sucessful
            Delete "$INSTDIR\CCPlusPlus9.zip"
        ${Else}
            DetailPrint "Error  - $Status"
        ${EndIf}
        DetailPrint "Downloading C# Compiler 8.0 Package..."
        inetc::get ${CompilerCSharp8Url} "$INSTDIR\CSharp8.zip"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status == OK 
            ${If} $IsUpdateMode == YES ; remove current files
                RMDir /r "$INSTDIR\compilers\c#\8.0"
            ${EndIf}
            CreateDirectory "$INSTDIR\compilers\c#"
            DetailPrint "Unpacking C# Compiler 8.0 Package..."
            nsisunz::Unzip "$INSTDIR\CSharp8.zip" "$INSTDIR\compilers\c#"
            Pop $Status ; 'success' when sucessful
            Delete "$INSTDIR\CSharp8.zip"
        ${Else}
            DetailPrint "Error  - $Status"
        ${EndIf}
        DetailPrint "Downloading C# Compiler 15.0 Package..."
        inetc::get ${CompilerCSharp15Url} "$INSTDIR\CSharp15.zip"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status == OK 
            ${If} $IsUpdateMode == YES ; remove current files
                RMDir /r "$INSTDIR\compilers\c#\15.0"
            ${EndIf}
            CreateDirectory "$INSTDIR\compilers\c#"
            DetailPrint "Unpacking C# Compiler 15.0 Package...."
            nsisunz::Unzip "$INSTDIR\CSharp15.zip" "$INSTDIR\compilers\c#"
            Pop $Status ; 'success' when sucessful
            Delete "$INSTDIR\CSharp15.zip"
        ${Else}
            DetailPrint "Error  - $Status"
        ${EndIf}

        DetailPrint "Downloading C# Compiler 16.0 Package..."
        inetc::get ${CompilerCSharp16Url} "$INSTDIR\vsbuildtools16.exe"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status == OK 
            CreateDirectory "$INSTDIR\compilers\c#"
            DetailPrint "Installing MSBuild 16 / C# Compiler Package...."
            ;ExecWait 'cmd /c start /wait " " "$INSTDIR\vsbuildtools16.exe" --installPath "$INSTDIR\compilers\c#\16.0" --allWorkloads --add Component.Android.SDK28 --add Component.Android.SDK29 --add Microsoft.VisualStudio.Component.Roslyn.LanguageServices --passive --norestart --wait'
            StrCpy $8 '"$INSTDIR\vsbuildtools16.exe" --installPath "$INSTDIR\compilers\c#\16.0" --allWorkloads --add Component.Android.SDK28 --add Component.Android.SDK29 --add Microsoft.VisualStudio.Component.Roslyn.LanguageServices --passive --norestart --wait'
            !insertmacro ExecWaitJob r8
        ${Else}
            DetailPrint "Error  - $Status"
        ${EndIf}
    ${EndIf}

    ;
    ; .NET SDK BUNDLES/PACKAGES
    ;
    ${If} $InstallNetSdks == YES
        DetailPrint "Downloading .NET Framework Packages..."
        inetc::get ${DotNetPackageUrl} "$INSTDIR\DotNetPackage.zip"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status == OK 
            ${If} $IsUpdateMode == YES ; remove current files
                RMDir /r "$INSTDIR\dotnet"
            ${EndIf}
            CreateDirectory "$INSTDIR\dotnet"
            DetailPrint "Unpacking .NET Framework Packages...."
            nsisunz::Unzip "$INSTDIR\DotNetPackage.zip" "$INSTDIR\dotnet"
            Pop $Status ; 'success' when sucessful
            Delete "$INSTDIR\DotNetPackage.zip"
        ${Else}
            DetailPrint "Error  - $Status"
        ${EndIf}

        inetc::get ${NugetCliUrl} "$INSTDIR\bin"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status != OK
            DetailPrint "Error  - $Status"
        ${EndIf}
    ${EndIf}

    ;
    ; Create sdks directory structure if required
    ;
    ${If} $InstallLegacySdks == YES
    ;${OrIf} $InstallNetSdks == YES
        CreateDirectory "$INSTDIR\sdks"
    ${EndIf}

    ;
    ; LEGACY SDKS
    ;
    ${If} $InstallLegacySdks == YES
        DetailPrint "Downloading Legacy SDK for PJA - Wix..."
        inetc::get ${LegacyWixUrl} "$INSTDIR\LegacyWix.zip"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status == OK 
            ${If} $IsUpdateMode == YES ; remove current files
                RMDir /r "$INSTDIR\sdks\wix"
            ${EndIf}
            DetailPrint "Unpacking Legacy SDK for PJA - Wix Package...."
            nsisunz::Unzip "$INSTDIR\LegacyWix.zip" "$INSTDIR\sdks"
            Pop $Status ; 'success' when sucessful
            Delete "$INSTDIR\LegacyWix.zip"
        ${Else}
            DetailPrint "Error  - $Status"
        ${EndIf}
        DetailPrint "Downloading Legacy SDK for PJA - AtlMfc..."
        inetc::get ${LegacyAtlMfcUrl} "$INSTDIR\LegacyAtlMfc.zip"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status == OK 
            ${If} $IsUpdateMode == YES ; remove current files
                RMDir /r "$INSTDIR\sdks\atlmfc"
            ${EndIf}
            DetailPrint "Unpacking Legacy SDK for PJA - AtlMfc Package...."
            nsisunz::Unzip "$INSTDIR\LegacyAtlMfc.zip" "$INSTDIR\sdks"
            Pop $Status ; 'success' when sucessful
            Delete "$INSTDIR\LegacyAtlMfc.zip"
        ${Else}
            DetailPrint "Error  - $Status"
        ${EndIf}
        DetailPrint "Downloading Legacy SDK for PJA - Windows August 2009..."
        inetc::get ${LegacyWindows2009Url} "$INSTDIR\WindowsAugust2009.zip"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status == OK 
            ${If} $IsUpdateMode == YES ; remove current files
                RMDir /r "$INSTDIR\sdks\windows\august2009"
            ${EndIf}
            CreateDirectory "$INSTDIR\sdks\windows"
            DetailPrint "Unpacking Legacy SDK for PJA - Windows August 2009 Package...."
            nsisunz::Unzip "$INSTDIR\WindowsAugust2009.zip" "$INSTDIR\sdks\windows"
            Pop $Status ; 'success' when sucessful
            Delete "$INSTDIR\WindowsAugust2009.zip"
        ${Else}
            DetailPrint "Error  - $Status"
        ${EndIf}
    ${EndIf}

    ;
    ; Notepad++
    ;
    ${If} $InstallNotepad == YES
        DetailPrint "Downloading Notepad++ for Windows..."
        inetc::get ${NotepadUrl} "$INSTDIR\npp.zip"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status == OK 
            ${If} $IsUpdateMode == YES ; remove current files
                RMDir /r "$INSTDIR\notepad++"
            ${EndIf}
            CreateDirectory "$INSTDIR\notepad++"
            DetailPrint "Unpacking Notepad++..."
            nsisunz::Unzip "$INSTDIR\npp.zip" "$INSTDIR\notepad++"
            Pop $Status ; 'success' when sucessful
            Delete "$INSTDIR\npp.zip"
            ${If} $IsUpdateMode != YES
                Push "$INSTDIR\npp"
                Call AddToPath
            ${EndIf}
        ${Else}
            DetailPrint "Error  - $Status"
        ${EndIf}
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
        WriteRegDWORD HKLM "$0" "EstimatedSize" 3480000
        WriteRegStr   HKLM "$0" "InstallLocation" "$INSTDIR"
        WriteRegDWORD HKLM "$0" "NoModify" 0
        WriteRegDWORD HKLM "$0" "NoRepair" 1
        WriteRegStr   HKLM "$0" "Publisher" "Scott Meesseman"
        WriteRegStr   HKLM "$0" "ModifyPath" "$INSTDIR\${INSTALL_FILE_NAME}"
        WriteRegStr   HKLM "$0" "UninstallString" "$INSTDIR\${UNINSTALL_FILE_NAME}"
        WriteRegStr   HKLM "$0" "QuietUninstallString" "$\"$INSTDIR\${UNINSTALL_FILE_NAME}$\" /S"
    ${EndIf}

    ; Set context to 'All Users'
    SetShellVarContext "all"

    ;
    ; CREATE UNINSTALLER AND COPY INSTALLER TO INSTALLDIR
    ;
    WriteUninstaller "$INSTDIR\${UNINSTALL_FILE_NAME}"
    ${If} $IsUpdateMode != YES
        CopyFiles "$EXEPATH" "$INSTDIR"
    ${Else}
        ;
        ; If this is the previously installed installer file running, cant copy it on itself
        ; If this is a new installer, copy it into the installdir for 'Change' functionality in
        ; the Windows Add/Remove Programs list
        ;
        ${If} "$INSTDIR" != "$EXEDIR"
            CopyFiles "$EXEPATH" "$INSTDIR"
        ${EndIf}
    ${EndIf}

SectionEnd


;SectionGroup /e "Visual Studio Code"
; 
;    Section "Stable" vscode_stable
;        
;    SectionEnd
;    
;    Section "Insiders" vscode_insiders
;
;    SectionEnd
; 
;SectionGroupEnd


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
        DetailPrint "Uninstalling Visual Studio Code..."
        ; uninstall vscode
        ; uninstaller for vscode exe installer (using zip not installer)
        ;ExecWait '"$INSTDIR\unins000.exe" /SILENT /SUPPRESSMSGBOXES'
        ; Extensions
        ExecWait '"$INSTDIR\install_extensions.bat" --uninstall-extension code'
        ; Desktop shortcut
        Delete "$DESKTOP\Code.lnk"
        Push "$INSTDIR\bin"
        Call un.RemoveFromPath
        Push "CODE_HOME"
        Call un.DeleteEnvVar
        DeleteRegKey HKCR "*\shell\Open with VS Code"
        DeleteRegKey HKCR "Directory\shell\vscode"
        DeleteRegKey HKCR "Directory\Background\shell\vscode"
        DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPLICATION_NAME}"
        ;RMDir /r "$PROFILE\.vscode\extensions"
        RMDir /r "$INSTDIR\data\extensions"
        RMDir /r "$INSTDIR\bin"
        RMDir /r "$INSTDIR\locales"
        RMDir /r "$INSTDIR\resources"
        RMDir /r "$INSTDIR\tools"
        Delete "$INSTDIR\*.dll"
        Delete "$INSTDIR\*.pak"
        Delete "$INSTDIR\*.bin"
        Delete "$INSTDIR\*.bat"
        Delete "$INSTDIR\*.dat"
        Delete "$INSTDIR\*.bin"
        Delete "$INSTDIR\Code*"
        MessageBox MB_YESNO "Delete user settings and cache?" IDYES 0 IDNO code1
            ;RMDir /r "$APPDATA\Code"
            ;RMDir /r "$PROFILE\AppData\Roaming\Code"
            ;RMDir /r "$PROFILE\.vscode"
            RMDir /r "$INSTDIR\data"
        code1:
    ${EndIf}

    ;
    ; CODE INSIDERS
    ;
    ${If} $InstallInsiders == YES 
        DetailPrint "Uninstalling Visual Studio Code Insiders..."
        ; Extensions
        ExecWait '"$INSTDIR\insiders\install_extensions.bat" --uninstall-extension code-insiders'
        Delete "$DESKTOP\Code Insiders.lnk"
	    ;RMDir /r "$PROFILE\.vscode\extensions"
        RMDir /r "$INSTDIR\insiders\data\extensions"
        RMDir /r "$INSTDIR\insiders\bin"
        RMDir /r "$INSTDIR\insiders\locales"
        RMDir /r "$INSTDIR\insiders\resources"
        RMDir /r "$INSTDIR\insiders\tools"
        Delete "$INSTDIR\insiders\*.dll"
        Delete "$INSTDIR\insiders\*.pak"
        Delete "$INSTDIR\insiders\*.bin"
        Delete "$INSTDIR\insiders\*.bat"
        Delete "$INSTDIR\insiders\*.dat"
        Delete "$INSTDIR\insiders\*.bin"
        Delete "$INSTDIR\insiders\Code*"
        MessageBox MB_YESNO "Delete Insiders user settings and cache?" IDYES 0 IDNO code2
            ;RMDir /r "$APPDATA\Code - Insiders"
            ;RMDir /r "$PROFILE\AppData\Roaming\Code - Insiders"
            ;RMDir /r "$PROFILE\.vscode-insiders"
            RMDir /r "$INSTDIR\insiders\data"
        code2:
    ${EndIf}

    ;
    ; NODEJS
    ;
    ${If} $InstallNodeJs == YES 
        DetailPrint "Uninstalling NodeJs/NPM..."
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
        DetailPrint "Uninstalling Git for Windows..."
        ExecWait '"$INSTDIR\git\unins000.exe" /SILENT /SUPPRESSMSGBOXES'
        RMDir /r "$INSTDIR\git"
        Delete /REBOOTOK "$INSTDIR\GitSetup.exe"
    ${EndIf}

    ;
    ; TORTOISESVN
    ;
    ${If} $InstallTortoise == YES 
        DetailPrint "Uninstalling TortoiseSVN..."
        ExecWait 'msiexec /x "$INSTDIR\TortoiseSVN-1.11.1.28492-x64-svn-1.11.1.msi" /passive REBOOT=ReallySuppress MSIRESTARTMANAGERCONTROL=Disable'
        RMDir /r "$INSTDIR\tortoisesvn"
        Delete /REBOOTOK "$INSTDIR\TortoiseSetup.msi"
    ${EndIf}

    ;
    ; CYGWIN
    ;
    ${If} $InstallCygwin == YES 
        DetailPrint "Uninstalling Cygwin..."
        ;ExecWait '$INSTDIR\cygwin-setup.exe --uninstall'
        Push "$INSTDIR\cygwin64\bin"
        Call un.RemoveFromPath
        RMDir /r "$INSTDIR\cygwin64"
        Delete /REBOOTOK "$INSTDIR\cygwin-setup.exe"
    ${EndIf}

    ;
    ; .NET472 DEV PACK
    ;
    ${If} $InstallNet472DevPack == YES 
        DetailPrint "Uninstalling .NET 4.72 Dev and Targeting Pack..."
        IfFileExists "$INSTDIR\NDP472-DevPack.exe" 0 net472pack1
            ExecWait '"$INSTDIR\NDP472-DevPack.exe" /uninstall /passive /noreboot'
            Delete /REBOOTOK "$INSTDIR\NDP472-DevPack.exe"
        net472pack1:
    ${EndIf}

    ;
    ; .NET SDKS
    ;
    ${If} $InstallNetSdks == YES 
        DetailPrint "Uninstalling .NET Framework Packages..."
        RMDir /r "$INSTDIR\dotnet"
    ${EndIf}

    ;
    ; LEGACY SDKS
    ;
    ${If} $InstallLegacySdks == YES 
        DetailPrint "Uninstalling Legacy SDKs for PJA..."
        RMDir /r "$INSTDIR\sdks\windows"
        RMDir /r "$INSTDIR\sdks\atlmfc"
        RMDir /r "$INSTDIR\sdks\wix"
    ${EndIf}

    ${If} $InstallNetSdks == YES 
    ;${AndIf} $InstallLegacySdks == YES 
        RMDir /r "$INSTDIR\sdks"
    ${EndIf}

    ;
    ; ANT
    ;
    ${If} $InstallAntAnsicon == YES 
        DetailPrint "Uninstalling Ant/Ansicon..."
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
        DetailPrint "Uninstalling Gradle..."
        Push "$INSTDIR\gradle\bin"
        Call un.RemoveFromPath
        RMDir /r "$INSTDIR\gradle"
    ${EndIf}
    
    ;
    ; COMPILERS PACK
    ;
    ${If} $InstallCompilers == YES 
        DetailPrint "Uninstalling Compilers Pack..."
        ;ExecWait 'cmd /c start /wait " " "$INSTDIR\vsbuildtools16.exe" uninstall --installPath "$INSTDIR\compilers\c#\16.0" --passive --norestart --wait'
        StrCpy $8 '"$INSTDIR\vsbuildtools16.exe" uninstall --installPath "$INSTDIR\compilers\c#\16.0" --passive --norestart --wait'
        !insertmacro ExecWaitJob r8
        RMDir /r "$INSTDIR\compilers"
    ${EndIf}

    ;
    ; DOTFUSCATOR
    ;
    ${If} $InstallDotfuscator == YES 
        DetailPrint "Uninstalling Dotfuscator Community Edition..."
        RMDir /r "$INSTDIR\dotfuscator\ce"
        RMDir "$INSTDIR\dotfuscator"
    ${EndIf}

    ;
    ; NSIS
    ;
    ${If} $InstallNsis == YES 
        DetailPrint "Uninstalling Nullsoft Scriptable Installer (NSIS)..."
        Push "$INSTDIR\nsis"
        Call un.RemoveFromPath
        RMDir /r "$INSTDIR\nsis"
    ${EndIf}

    ;
    ; PHP
    ;
    ${If} $InstallPhp == YES 
        DetailPrint "Uninstalling PHP for Windows..."
        Push "$INSTDIR\php"
        Call un.RemoveFromPath
        RMDir /r "$INSTDIR\php"
    ${EndIf}

    ;
    ; PYTHON
    ;
    ${If} $InstallPython == YES 
        DetailPrint "Uninstalling Python for Windows..."
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
    ; Notepad++
    ;
    ${If} $InstallNotepad == YES 
        DetailPrint "Uninstalling Notepad++..."
        Push "$INSTDIR\notepad++"
        Call un.RemoveFromPath
        RMDir /r "$INSTDIR\notepad++"
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
    ${AndIf} $InstallCygwin == YES
    ${AndIf} $InstallGradle == YES
    ${AndIf} $InstallNetSdks == YES
    ${AndIf} $InstallPython == YES
    ${AndIf} $InstallLegacySdks == YES
    ${AndIf} $InstallDotfuscator == YES
    ${AndIf} $InstallNsis == YES
    ${AndIf} $InstallPhp == YES
    ${AndIf} $InstallNotepad == YES
    ${AndIf} $InstallNet472DevPack == YES
        RMDir /r "$INSTDIR"
    ${Else}
        RMDir "$INSTDIR" 
    ${EndIf}

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
;*      .onSelChange                                                 * 
;*                                                                   * 
;*********************************************************************

; For testing MUI_PAGE_COMPONENTS

;Function .onSelChange
;
;    ;
;    ; VSCode Stable
;    ;
;    SectionGetFlags ${vscode_stable} $R0
;    IntOp $R0 $R0 & ${SF_SELECTED}
;    ${If} $R0 == ${SF_SELECTED}
;        ;!insertmacro ClearSectionFlag ${sec2} ${SF_RO}
;        StrCpy $InstallCode YES
;    ${Else}
;        ;!insertmacro UnSelectSection ${sec2}
;        ;!insertmacro SetSectionFlag ${sec2} ${SF_RO}
;        StrCpy $InstallCode NO
;    ${EndIf}
;
;    ;
;    ; VSCode Insiders
;    ;
;    ;SectionGetFlags ${Sec2} $WithOption
;    SectionGetFlags ${vscode_insiders} $R0
;    ${If} $R0 == ${SF_SELECTED}
;        ;!insertmacro ClearSectionFlag ${sec2} ${SF_RO}
;        StrCpy $InstallInsiders YES
;    ${Else}
;        ;!insertmacro UnSelectSection ${sec2}
;        ;!insertmacro SetSectionFlag ${sec2} ${SF_RO}
;        StrCpy $InstallInsiders NO
;    ${EndIf}
;
;FunctionEnd


;*********************************************************************
;*                                                                   * 
;*      dirPre                                                       * 
;*                                                                   * 
;*********************************************************************

Function dirPre
    ${If} $IsUpdateMode == YES ; skip insall dir window if update mode
        Abort                  ; INSTDIR is set in .onInit
    ${EndIf}
FunctionEnd


;*********************************************************************
;*                                                                   * 
;*      InstAuthPageCreate                                           * 
;*                                                                   * 
;*********************************************************************

Function InstAuthPageCreate

    ${If} $InstallDotfuscator != YES
        Abort
    ${EndIf}

    nsDialogs::Create 1018
    Pop $1

    !insertmacro MUI_HEADER_TEXT "Visual Studio Code Based Development Environment" \
                                 "Some chosen packages require registration" 

    
    ${NSD_CreateLabel} 0 20u 100% 10u "Enter the URL for Dotfuscator CE"
    Pop $2

    ${NSD_CreateText} 0 50u 100% 12u "https://"
    Pop $3
    
    nsDialogs::Show
    
FunctionEnd


;*********************************************************************
;*                                                                   * 
;*      InstAuthPageLeave                                            * 
;*                                                                   * 
;*********************************************************************

Function InstAuthPageLeave

    ;${NSD_GetText} $3 $DotfuscatorUrl
    System::Call user32::GetWindowText(i r3, t .r4, i ${NSIS_MAX_STRLEN} i .n)
    StrCpy $DotfuscatorUrlVar "$4"
    DetailPrint "Dotfuscator url entered is $DotfuscatorUrlVar"

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

    ${If} $InstallsSaved != YES
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
        ${If} $InstallCygwin == ""
            StrCpy $InstallCygwin YES
        ${EndIf}
        ${If} $InstallGit == ""
            StrCpy $InstallGit YES
        ${EndIf}
        StrCpy $InstallDotfuscator NO
        ${If} $InstallNsis == ""
            StrCpy $InstallNsis YES
        ${EndIf}
        ${If} $InstallPhp == ""
            StrCpy $InstallPhp YES
        ${EndIf}
        ${If} $InstallNotepad == ""
            StrCpy $InstallNotepad YES
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
    ${Endif}

    SetRegView 64

    ${NSD_CreateCheckBox} 0 20u 45% 10u "Visual Studio Code"
    Pop $R9
    ${If} $IsUpdateMode != YES
        EnableWindow $R9 0
    ${EndIf}
    ${If} $InstallCode == YES 
        ${NSD_Check} $R9
    ${EndIf}

    ${NSD_CreateCheckBox} 0 35u 45% 10u "Visual Studio Code Insiders"
    Pop $2
    IfFileExists "$INSTDIR\insiders\Code - Insiders.exe" 0 insidersdone
        ${If} $InstallsSaved != YES
            StrCpy $InstallInsiders NO
        ${EndIf}
    insidersdone:
    ${If} $InstallInsiders == YES
        ${NSD_Check} $2
    ${EndIf}

    ${NSD_CreateCheckBox} 0 50u 45% 10u "NodeJS and Package Manager (NPM)"
    Pop $R6
    ${If} $IsUpdateMode != YES
        EnableWindow $R6 0
        ${NSD_Check} $R6
    ${EndIf}
    IfFileExists "$INSTDIR\nodejs\npm.cmd" 0 nodejsdone
        ${If} $InstallsSaved != YES
            StrCpy $InstallNodeJs NO
            EnableWindow $R6 1
            ${NSD_Uncheck} $R6
        ${Endif}
    nodejsdone:
    ${If} $InstallNodeJs == YES
        ${NSD_Check} $R6
    ${EndIf}

    ${NSD_CreateCheckBox} 0 65u 45% 10u "Tortoise SVN + Cmd Line Tools"
    Pop $4
    ReadRegStr $R0 HKLM "SOFTWARE\TortoiseSVN" "Directory"  ; Check to see if already installed
    IfFileExists "$R0\bin\svn.exe" 0 svndone
        EnableWindow $4 0
        ${If} $InstallsSaved != YES
            StrCpy $InstallTortoise NO
        ${EndIf}
    svndone:
    ${If} $InstallTortoise == YES 
        ${NSD_Check} $4
    ${EndIf}

    ${NSD_CreateCheckBox} 0 80u 45% 10u "Git for Windows"
    Pop $5
    ReadRegStr $R0 HKLM "SOFTWARE\GitForWindows" "InstallPath"  ; Check to see if already installed
    IfFileExists "$R0\bin\git.exe" 0 gitdone
        EnableWindow $5 0
        ${If} $InstallsSaved != YES
            StrCpy $InstallGit NO
        ${EndIf}
    gitdone:
    ${If} $InstallGit == YES
        ${NSD_Check} $5
    ${EndIf}

    ${NSD_CreateCheckBox} 0 95u 45% 10u "Dotfuscator Community Edition"
    Pop $6
    # IfFileExists "$INSTDIR\dotfuscator\ce\DotfuscatorCLI.exe" 0 dotfuscatordone
    #    ${If} $InstallsSaved != YES
            StrCpy $InstallDotfuscator NO
    #    ${EndIf}
    #dotfuscatordone:
    ${If} $InstallDotfuscator == YES
        ${NSD_Check} $6
    ${EndIf}

    ${NSD_CreateCheckBox} 0 110u 45% 10u "C#/C/C++ Compiler Packages"
    Pop $R5
    IfFileExists "$INSTDIR\compilers\c#\15.0\Bin\MSBuild.exe" 0 compilersdone
        ${If} $InstallsSaved != YES
            StrCpy $InstallCompilers NO
        ${EndIf}
    compilersdone:
    ${If} $InstallCompilers == YES
        ${NSD_Check} $R5
    ${EndIf}

    ${NSD_CreateCheckBox} 0 125u 45% 10u "Cygwin for Windows"
    Pop $R7
    IfFileExists "$INSTDIR\cygwin64\bin\bash.exe" 0 cygwindone
        ${If} $InstallsSaved != YES
            StrCpy $InstallCygwin NO
        ${EndIf}
    cygwindone:
    ${If} $InstallCygwin == YES
        ${NSD_Check} $R7
    ${EndIf}

    ${NSD_CreateCheckBox} 0 140u 45% 10u "Notepad++"
    Pop $1
    IfFileExists "$INSTDIR\notepad++\notepad++.exe" 0 notepaddone
        ${If} $InstallsSaved != YES
            StrCpy $InstallNotepad NO
        ${EndIf}
    notepaddone:
    ${If} $InstallNotepad == YES
        ${NSD_Check} $1
    ${EndIf}

    ${NSD_CreateCheckBox} 150u 20u 45% 10u "Apache Ant with Ansicon"
    Pop $R3
    IfFileExists "$INSTDIR\ant\bin\ant.bat" 0 antdone
        ${If} $InstallsSaved != YES
            StrCpy $InstallAntAnsicon NO
        ${EndIf}
    antdone:
    ${If} $InstallAntAnsicon == YES
        ${NSD_Check} $R3
    ${EndIf}

    ${NSD_CreateCheckBox} 150u 35u 45% 10u "Gradle Build Tool"
    Pop $R4
    IfFileExists "$INSTDIR\gradle\bin\gradle.bat" 0 gradledone
        ${If} $InstallsSaved != YES
            StrCpy $InstallGradle NO
        ${EndIf}
    gradledone:
    ${If} $InstallGradle == YES
        ${NSD_Check} $R4
    ${EndIf}

    ${NSD_CreateCheckBox} 150u 50u 45% 10u "Nullsoft Scriptable Installer (NSIS)"
    Pop $7
    IfFileExists "$INSTDIR\nsis\makensis.exe" 0 nsisdone
        ${If} $InstallsSaved != YES
            StrCpy $InstallNsis NO
        ${EndIf}
    nsisdone:
    ${If} $InstallNsis == YES
        ${NSD_Check} $7
    ${EndIf}

    ${NSD_CreateCheckBox} 150u 65u 45% 10u "Python for Windows"
    Pop $8
    IfFileExists "$INSTDIR\python\scripts\pip.exe" 0 pythondone
        ${If} $InstallsSaved != YES
            StrCpy $InstallPython NO
        ${EndIf}
    pythondone:
    ${If} $InstallPython == YES 
        ${NSD_Check} $8
    ${EndIf}

    ${NSD_CreateCheckBox} 150u 80u 45% 10u ".NET Framework Packages"
    Pop $R1
    IfFileExists "$INSTDIR\dotnet\net472\Accessibility.dll" 0 netsdksdone
        ${If} $InstallsSaved != YES
            StrCpy $InstallNetSdks NO
        ${EndIf}
    netsdksdone:
    ${If} $InstallNetSdks == YES
        ${NSD_Check} $R1
    ${EndIf}
    
    ${NSD_CreateCheckBox} 150u 95u 45% 10u ".NET 4.72 Targeting and Dev Pack"
    Pop $3
    IfFileExists "$INSTDIR\NDP472-DevPack.exe" 0 net472done
        ${If} $InstallsSaved != YES
            StrCpy $InstallNet472DevPack NO
        ${EndIf}
    net472done:
    ${If} $InstallNet472DevPack == YES
        ${NSD_Check} $3
    ${EndIf}

    ${NSD_CreateCheckBox} 150u 110u 45% 10u "Legacy SDKs for PJA Projects"
    Pop $R2
    IfFileExists "$INSTDIR\sdks\atlmfc\lib\atl.lib" 0 legacysdksdone
        ${If} $InstallsSaved != YES
            StrCpy $InstallLegacySdks NO
        ${EndIf}
    legacysdksdone:
    ${If} $InstallLegacySdks == YES
        ${NSD_Check} $R2
    ${EndIf}

    ${NSD_CreateCheckBox} 150u 125u 45% 10u "PHP for Windows"
    Pop $R8
    IfFileExists "$INSTDIR\php\php-win.exe" 0 phpdone
        ${If} $InstallsSaved != YES
            StrCpy $InstallPhp NO
        ${EndIf}
    phpdone:
    ${If} $InstallPhp == YES
        ${NSD_Check} $R8
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

    StrCpy $InstallsSaved YES

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

    ${NSD_GetState} $R7 $0
    ${If} $0 != ${BST_CHECKED}
        StrCpy $InstallCygwin NO
    ${Else}
        StrCpy $InstallCygwin YES
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

    ${NSD_GetState} $R8 $0
    ${If} $0 != ${BST_CHECKED}
        StrCpy $InstallPhp NO
    ${Else}
        StrCpy $InstallPhp YES
    ${EndIf}

    ${NSD_GetState} $1 $0
    ${If} $0 != ${BST_CHECKED}
        StrCpy $InstallNotepad NO
    ${Else}
        StrCpy $InstallNotepad YES
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
    ${AndIf} $InstallCygwin == NO
    ${AndIf} $InstallGradle == NO
    ${AndIf} $InstallNetSdks == NO
    ${AndIf} $InstallPython == NO
    ${AndIf} $InstallLegacySdks == NO
    ${AndIf} $InstallDotfuscator == NO
    ${AndIf} $InstallNsis == NO
    ${AndIf} $InstallPhp == NO
    ${AndIf} $InstallNotepad == NO
    ${AndIf} $InstallNet472DevPack == NO
        MessageBox MB_OK|MB_ICONEXCLAMATION        \
            "You must select at least one package to update" \
        IDOK 0
            Abort
    ${Endif}

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
                                 "Choose Packages to Uninstall" 

    ${If} $InstallsSaved != YES
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
        ${If} $InstallCygwin == ""
            StrCpy $InstallCygwin YES
        ${EndIf}
        ${If} $InstallGit == ""
            StrCpy $InstallGit YES
        ${EndIf}
        ${If} $InstallDotfuscator == ""
            StrCpy $InstallDotfuscator NO
        ${EndIf}
        ${If} $InstallNsis == ""
            StrCpy $InstallNsis YES
        ${EndIf}
        ${If} $InstallPhp == ""
            StrCpy $InstallPhp YES
        ${EndIf}
        ${If} $InstallNotepad == ""
            StrCpy $InstallNotepad YES
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
    ${Endif}

    SetRegView 64

    ${NSD_CreateCheckBox} 0 20u 45% 10u "Visual Studio Code"
    Pop $R9
    ${If} $InstallCode == YES 
        ${NSD_Check} $R9
    ${EndIf}

    ${NSD_CreateCheckBox} 0 35u 45% 10u "Visual Studio Code Insiders"
    Pop $2
    ${IfNot} ${FileExists} "$INSTDIR\insiders\Code - Insiders.exe"
        ${NSD_Uncheck} $2
        EnableWindow $2 0
        StrCpy $InstallInsiders NO
    ${EndIf}
    ${If} $InstallInsiders == YES
        ${NSD_Check} $2
    ${EndIf}
    
    ${NSD_CreateCheckBox} 0 50u 45% 10u "NodeJS and Package Manager (NPM)"
    Pop $R6
    ${IfNot} ${FileExists} "$INSTDIR\nodejs\npm.cmd"
        ${NSD_Uncheck} $R6
        EnableWindow $R6 0
        StrCpy $InstallNodeJs NO
    ${EndIf}
    ${If} $InstallNodeJs == YES
        ${NSD_Check} $R6
    ${EndIf}

    ${NSD_CreateCheckBox} 0 65u 45% 10u "Tortoise SVN + Cmd Line Tools"
    Pop $4
    ReadRegStr $R0 HKLM "SOFTWARE\TortoiseSVN" "Directory"  ; Check to see if already installed
    ${IfNot} ${FileExists} "$R0\bin\svn.exe"
        ${NSD_Uncheck} $4
        EnableWindow $4 0
        StrCpy $InstallTortoise NO
    ${EndIf}
    ${If} $InstallTortoise == YES
        ${NSD_Check} $4
    ${EndIf}

    ${NSD_CreateCheckBox} 0 80u 45% 10u "Git for Windows"
    Pop $5
    ReadRegStr $R0 HKLM "SOFTWARE\GitForWindows" "InstallPath"  ; Check to see if already installed
    ${IfNot} ${FileExists} "$R0\bin\git.exe"
        ${NSD_Uncheck} $5
        EnableWindow $5 0
        StrCpy $InstallGit NO
    ${EndIf}
    ${If} $InstallGit == YES
        ${NSD_Check} $5
    ${EndIf}

    ${NSD_CreateCheckBox} 0 95u 45% 10u "Dotfuscator Community Edition"
    Pop $6
    ${IfNot} ${FileExists} "$INSTDIR\dotfuscator\ce\DotfuscatorCLI.exe"
        ${NSD_Uncheck} $6
        EnableWindow $6 0
        StrCpy $InstallDotfuscator NO
    ${EndIf}
    ${If} $InstallDotfuscator == YES
        ${NSD_Check} $6
    ${EndIf}

    ${NSD_CreateCheckBox} 0 110u 45% 10u "C#/C/C++ Compiler Package"
    Pop $R5
    ${IfNot} ${FileExists} "$INSTDIR\compilers\c#\15.0\Bin\MSBuild.exe"
        ${NSD_Uncheck} $R5
        EnableWindow $R5 0
        StrCpy $InstallCompilers NO
    ${EndIf}
    ${If} $InstallCompilers == YES
        ${NSD_Check} $R5
    ${EndIf}

    ${NSD_CreateCheckBox} 0 125u 45% 10u "Cygwin for Windows"
    Pop $R7
    ${IfNot} ${FileExists} "$INSTDIR\cygwin64\bin\bash.exe"
        ${NSD_Uncheck} $R7
        EnableWindow $R7 0
        StrCpy $InstallCygwin NO
    ${EndIf}
    ${If} $InstallCygwin == YES
        ${NSD_Check} $R7
    ${EndIf}

    ${NSD_CreateCheckBox} 0 140u 45% 10u "Notepad++"
    Pop $1
    ${IfNot} ${FileExists} "$INSTDIR\notepad++\notepad++.exe"
        ${NSD_Uncheck} $1
        EnableWindow $1 0
        StrCpy $InstallNotepad NO
    ${EndIf}
    ${If} $InstallNotepad == YES
        ${NSD_Check} $1
    ${EndIf}

    ${NSD_CreateCheckBox} 150u 20u 45% 10u "Apache Ant with Ansicon"
    Pop $R3
    ${IfNot} ${FileExists} "$INSTDIR\ant\bin\ant.bat"
        ${NSD_Uncheck} $R3
        EnableWindow $R3 0
        StrCpy $InstallAntAnsicon NO
    ${EndIf}
    ${If} $InstallAntAnsicon == YES
        ${NSD_Check} $R3
    ${EndIf}

    ${NSD_CreateCheckBox} 150u 35u 45% 10u "Gradle Build Tool"
    Pop $R4
    ${IfNot} ${FileExists} "$INSTDIR\gradle\bin\gradle.bat"
        ${NSD_Uncheck} $R4
        EnableWindow $R4 0
        StrCpy $InstallGradle NO
    ${EndIf}
    ${If} $InstallGradle == YES
        ${NSD_Check} $R4
    ${EndIf}

    ${NSD_CreateCheckBox} 150u 50u 45% 10u "Nullsoft Scriptable Installer (NSIS)"
    Pop $7
    ${IfNot} ${FileExists} "$INSTDIR\nsis\makensis.exe"
        ${NSD_Uncheck} $7
        EnableWindow $7 0
        StrCpy $InstallNsis NO
    ${EndIf}
    ${If} $InstallNsis == YES
        ${NSD_Check} $7
    ${EndIf}

    ${NSD_CreateCheckBox} 150u 65u 45% 10u "Python for Windows"
    Pop $8
    ${IfNot} ${FileExists} "$INSTDIR\python\scripts\pip.exe"
        ${NSD_Uncheck} $8
        EnableWindow $8 0
        StrCpy $InstallPython NO
    ${EndIf}
    ${If} $InstallPython == YES
        ${NSD_Check} $8
    ${EndIf}

    ${NSD_CreateCheckBox} 150u 80u 45% 10u ".NET Framework Packages"
    Pop $R1
    ${IfNot} ${FileExists} "$INSTDIR\dotnet\net472\Accessibility.dll"
        ${NSD_Uncheck} $R1
        EnableWindow $R1 0
        StrCpy $InstallNetSdks NO
    ${EndIf}
    ${If} $InstallNetSdks == YES
        ${NSD_Check} $R1
    ${EndIf}
    
    ${NSD_CreateCheckBox} 150u 95u 45% 10u ".NET 4.72 Targeting and Dev Pack"
    Pop $3
    ${IfNot} ${FileExists} "$INSTDIR\NDP472-DevPack.exe"
        ${NSD_Uncheck} $3
        EnableWindow $3 0
        StrCpy $InstallNet472DevPack NO
    ${EndIf}
    ${If} $InstallNet472DevPack == YES
        ${NSD_Check} $3
    ${EndIf}

    ${NSD_CreateCheckBox} 150u 110u 45% 10u "Legacy SDKs for PJA Projects"
    Pop $R2
    ${IfNot} ${FileExists} "$INSTDIR\sdks\atlmfc\lib\atl.lib"
        ${NSD_Uncheck} $R2
        EnableWindow $R2 0
        StrCpy $InstallLegacySdks NO
    ${EndIf}
    ${If} $InstallLegacySdks == YES
        ${NSD_Check} $R2
    ${EndIf}

    ${NSD_CreateCheckBox} 150u 125u 45% 10u "PHP for Windows"
    Pop $R8
    ${IfNot} ${FileExists} "$INSTDIR\php\php-win.exe"
        ${NSD_Uncheck} $R8
        EnableWindow $R8 0
        StrCpy $InstallPhp NO
    ${EndIf}
    ${If} $InstallPhp == YES
        ${NSD_Check} $R8
    ${EndIf}

    nsDialogs::Show

FunctionEnd


;*********************************************************************
;*                                                                   *
;*   Function Definition                                             *
;*                                                                   * 
;*      un.InstTypePageLeave                                         * 
;*                                                                   * 
;*********************************************************************

Function un.InstTypePageLeave
    
    StrCpy $InstallsSaved YES

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

    ${NSD_GetState} $R7 $0
    ${If} $0 != ${BST_CHECKED}
        StrCpy $InstallCygwin NO
    ${Else}
        StrCpy $InstallCygwin YES
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

    ${NSD_GetState} $R8 $0
    ${If} $0 != ${BST_CHECKED}
        StrCpy $InstallPhp NO
    ${Else}
        StrCpy $InstallPhp YES
    ${EndIf}

    ${NSD_GetState} $1 $0
    ${If} $0 != ${BST_CHECKED}
        StrCpy $InstallNotepad NO
    ${Else}
        StrCpy $InstallNotepad YES
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
    ${AndIf} $InstallCygwin == NO
    ${AndIf} $InstallTortoise == NO
    ${AndIf} $InstallGradle == NO
    ${AndIf} $InstallNetSdks == NO
    ${AndIf} $InstallPython == NO
    ${AndIf} $InstallLegacySdks == NO
    ${AndIf} $InstallDotfuscator == NO
    ${AndIf} $InstallNsis == NO
    ${AndIf} $InstallPhp == NO
    ${AndIf} $InstallNotepad == NO
    ${AndIf} $InstallNet472DevPack == NO
        MessageBox MB_OK|MB_ICONEXCLAMATION        \
            "You must select at least one package to remove or uninstall" \
        IDOK 0
            Abort
    ${Endif}

FunctionEnd
