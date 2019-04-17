
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
!define TortoiseUrl "https://github.com/spmeesseman/code-package/blob/master/src/tortoisesvn/tortoisesvn.msi?raw=true"
!define DotfuscatorUrl "https://github.com/spmeesseman/code-package/blob/master/src/dotfuscator/ce.zip?raw=true"
!define NsisUrl "https://github.com/spmeesseman/code-package/blob/master/src/nsis/nsis.zip?raw=true"
!define PythonUrl "https://github.com/spmeesseman/code-package/blob/master/src/python/python.zip?raw=true"
!define NodeJsUrl "https://github.com/spmeesseman/code-package/blob/master/src/nodejs/nodejs.zip?raw=true"
!define AntUrl "https://github.com/spmeesseman/code-package/blob/master/src/ant.ant.zip?raw=true"
!define AnsiconUrl "https://github.com/spmeesseman/code-package/blob/master/src/ansicon/ansicon.zip?raw=true"
!define GradleUrl "https://github.com/spmeesseman/code-package/blob/master/src/gradle/gradle.zip?raw=true"

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

Var CommandLine
Var CommandLineLength
Var CurrentOffset
Var CurrentValue
Var InstanceNumber
Var InstanceNumberEnd
Var InstanceNumberLength
Var InstanceNumberStart
Var Delimiter
Var Size
Var Status
Var InstallInsiders
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

;*********************************************************************
;*                                                                   *
;*   Instructions                                                    *
;*                                                                   * 
;*********************************************************************

; Define the 'BrandingText' text 
; This value is displayed in the lower left of each dialog window
BrandingText " "

; Force CRC checking
CRCCheck force

; Define the name which appears in the title bar
Name "${APPLICATION_NAME} ${BUILD_LEVEL} 64-bit"

; Define the name of the output file
OutFile "dist\${INSTALL_FILE_NAME}"

; Show details of install
ShowInstDetails show

; Show details of uninstall
ShowUninstDetails show

; Specify the pages to display when performing an Install
Page custom GetInstanceNumber
Page custom InstTypePageCreate InstTypePageLeave
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

; Specify the pages to display when performing an Uninstall
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

; Specify the language
!insertmacro MUI_LANGUAGE "English"

; Reserve the files
ReserveFile "InstanceNumber.ini"


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
    MessageBox MB_OKCANCEL "The latest version of Microsoft VS Code needs to be installed.$\n$\nBy continuing you are agreeing to Microsoft licensing terms." IDOK vscodetrue IDCANCEL vscodefalse
    vscodefalse:
        RMDir "$INSTDIR" ; Don't remove if not empty (/r)
        Abort
    vscodetrue:
    ;NSISdl::download ${GitDownloadUrl} "$INSTDIR\VSCode.exe"
    inetc::get ${CodeDownloadUrl} "$INSTDIR\VSCode.zip"
    ; 'OK' when sucessful
    Pop $Status
    ;StrCpy $Status "OK"
    StrCmp $Status "OK" status0_success 0
        RMDir "$INSTDIR" ; Don't remove if not empty (/r)
        Abort
    status0_success:
    ;ExecWait '"$INSTDIR\VSCode.exe" /SILENT /MERGETASKS="!runcode,addcontextmenufiles,addcontextmenufolders,associatewithfiles" /NORESTART /NOCANCEL /SUPPRESSMSGBOXES /DIR="$INSTDIR"'
    nsisunz::Unzip "$INSTDIR\VSCode.zip" "$INSTDIR"
    Pop $Status ; 'success' when sucessful
    Delete "$INSTDIR\VSCode.zip"
    CreateShortCut "$DESKTOP\Code.lnk" "$INSTDIR\code.exe"
    Push "$INSTDIR\bin"
    Call AddToPath
    Push "CODE_HOME"
    Push "$INSTDIR"
    Call AddToEnvVar
    
    ;
    ; EXTRACT THE LOCAL INSTALLER FILES - WITHOUT SETTINGS.JSON
    ;
    File /r /x settings.json ..\build\*.*

    ;
    ; NODEJS
    ;
    inetc::get ${NodeJsUrl} "$INSTDIR\NodeJs.zip"
    Pop $Status ; 'OK' when sucessful
    ${If} $Status == OK 
        nsisunz::Unzip "$INSTDIR\NodeJs.zip" "$INSTDIR"
        Pop $Status ; 'success' when sucessful
        Delete "$INSTDIR\NodeJs.zip"
        Push "$INSTDIR\nodejs"
        Call AddToPath
        Push "$INSTDIR\nodejs\node_modules\typescript\bin"
        Call AddToPath
    ${EndIf}

    ;
    ; VSCODE Insiders (latest/current version)
    ;
    ${If} $InstallInsiders == YES 
        inetc::get ${CodeInsidersDownloadUrl} "$INSTDIR\VSCodeInsiders.zip"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status == OK 
            ;ExecWait '"$INSTDIR\VSCode.exe" /SILENT /MERGETASKS="!runcode,addcontextmenufiles,addcontextmenufolders,associatewithfiles" /NORESTART /NOCANCEL /SUPPRESSMSGBOXES /DIR="$INSTDIR"'
            CreateDirectory "$INSTDIR\insiders"
            nsisunz::Unzip "$INSTDIR\VSCodeInsiders.zip" "$INSTDIR\insiders"
            Pop $Status ; 'success' when sucessful
            Delete "$INSTDIR\VSCodeInsiders.zip"
            CreateShortCut "$DESKTOP\Code Insiders.lnk" "$INSTDIR\insiders\Code - Insiders.exe"
        ${EndIf}
    ${EndIf}

    ;
    ; .NET 4.72 DEVELOPMENT PACK
    ;
    ${If} $InstallNet472DevPack == YES 
        inetc::get ${Net472DownloadUrl} "$INSTDIR\NDP472-DevPack.exe"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status == OK 
            ExecWait '"$INSTDIR\NDP472-DevPack.exe" /passive /noreboot'
        ${EndIf}
    ${EndIf}

    ;
    ; GIT
    ;
    ${If} $InstallGit == YES 
        inetc::get ${GitDownloadUrl} "$INSTDIR\GitSetup.exe"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status == OK 
            Push "$INSTDIR\git.inf"     ; copy install dir to inf file
            Push "C:\Program Files\Git" 
            Push "$INSTDIR\git"
            Call ReplaceInFile
            ExecWait '"$INSTDIR\GitSetup.exe" /SILENT /SUPPRESSMSGBOXES /NOCANCEL /NORESTART /SP- /LOADINF="$INSTDIR\git.inf" /DIR="$INSTDIR\git"'
        ${EndIf}
    ${EndIf}
    Delete "$INSTDIR\git.inf"

    ;
    ; TORTOISE SVN
    ;
    ${If} $InstallTortoise == YES
        inetc::get ${TortoiseUrl} "$INSTDIR\TortoisSetup.msi"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status == OK 
            ExecWait 'msiexec /i "$INSTDIR\TortoisSetup.msi" /passive /norestart INSTALLDIR="$INSTDIR\tortoisesvn" ADDLOCAL=ALL'
        ${EndIf}
    ${EndIf}

    ;
    ; NSIS
    ;
    ${If} $InstallNsis == YES
        inetc::get ${NsisUrl} "$INSTDIR\nsis.zip"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status == OK 
            nsisunz::Unzip "$INSTDIR\nsis.zip" "$INSTDIR"
            Pop $Status ; 'success' when sucessful
            Delete "$INSTDIR\nsis.zip"
            Push "$INSTDIR\nsis"
            Call AddToPath
        ${EndIf}
    ${EndIf}

    ;
    ; PYTHON
    ;
    ${If} $InstallPython == YES
        inetc::get ${PythonUrl} "$INSTDIR\python.zip"
        Pop $Status ; 'OK' when sucessful
        ${If} $Status == OK 
            nsisunz::Unzip "$INSTDIR\python.zip" "$INSTDIR"
            Pop $Status ; 'success' when sucessful
            Delete "$INSTDIR\python.zip"
            ; PYTHON PIP
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
            Push "$INSTDIR\python"
            Call AddToPath
            Push "$INSTDIR\python\Scripts"
            Call AddToPath
            Push "PYTHONPATH"
            Push "$INSTDIR\python;$INSTDIR\python\DLLs;$INSTDIR\python\lib;$INSTDIR\python\lib\plat-win;$INSTDIR\python\lib\site-packages;$INSTDIR\python\Scripts"
            Call AddToEnvVar
        ${EndIf}
    ${EndIf}

    ;
    ; EXTENSIONS
    ;
    ExecWait '"$INSTDIR\install_extensions.bat" --install-extension'
    ; Add 'johnstoncode.svn-scm' to enabledProposedApi list in subversion exension, this enabled the file explorer decorations
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
    ; Check if 'settings.json' exists in the target directory   
    ;IfFileExists "$INSTDIR\data\user-data\User\settings.json" SETTINGS_FILE_ALREADY_EXISTS 0
    IfFileExists "$APPDATA\Code\User\settings.json" SETTINGS_FILE_ALREADY_EXISTS 0
    ; Copy the file
    ;File /oname=data\user-data\User\settings.json ..\build\settings.json
    CreateDirectory "$APPDATA\Code"
    CreateDirectory "$APPDATA\Code\User"
    File /oname=$APPDATA\Code\User\settings.json ..\build\settings.json
    ; replace c:\code in settings.json with actual install dir
    ;Push "$INSTDIR\data\user-data\User\settings.json"
    Push "$APPDATA\Code\User\settings.json"
    Push "c:\Code" 
    Push "$INSTDIR"
    Call ReplaceInFile
    SETTINGS_FILE_ALREADY_EXISTS:

    ;
    ; CUSTOM FILES STUFF
    ;
    ExecWait '"$INSTDIR\copy_settings.bat"'
    Delete "$INSTDIR\copy_settings.bat"

    ;
    ; ADD TO PATH ENVIRONMENT VARIABLE
    ;
    Push "$INSTDIR\ant\bin"
    Call AddToPath
    Push "$INSTDIR\gradle\bin"
    Call AddToPath
    ; ADD CUSTOM VARIABLES TO ENVIRONMENT
    Push "ANT_HOME"
    Push "$INSTDIR\ant"
    Call AddToEnvVar

    ; Define our delimiter
    StrCpy $Delimiter "#"

    ; ADD REGISTRY KEYS - VSCODE WINDOWS EXPLORER CONTEXT MENUS
    WriteRegStr   HKCR                                                                                      \
                    "*\shell\Open with VS Code"                                                               \
                    ""                                                                                        \
                    "Edit with VS Code"     
    WriteRegStr   HKCR                                                                                      \
                    "*\shell\Open with VS Code"                                                               \
                    "Icon"                                                                                    \
                    "$INSTDIR\Code.exe,0"     
    WriteRegStr   HKCR                                                                                      \
                    "*\shell\Open with VS Code\command"                                                       \
                    ""                                                                                        \
                    '"$INSTDIR\Code.exe" "%1"'     
    WriteRegStr   HKCR                                                                                      \
                    "Directory\shell\vscode"                                                                  \
                    ""                                                                                        \
                    "Open Folder as VS Code Project"     
    WriteRegStr   HKCR                                                                                      \
                    "Directory\shell\vscode"                                                                  \
                    "Icon"                                                                                    \
                    "$INSTDIR\Code.exe,0"     
    WriteRegStr   HKCR                                                                                      \
                    "Directory\shell\vscode\command"                                                          \
                    ""                                                                                        \
                    '"$INSTDIR\Code.exe" "%1"'     
    WriteRegStr   HKCR                                                                                      \
                    "Directory\Background\shell\vscode"                                                       \
                    ""                                                                                        \
                    "Open Folder as VS Code Project"     
    WriteRegStr   HKCR                                                                                      \
                    "Directory\Background\shell\vscode"                                                       \
                    "Icon"                                                                                    \
                    "$INSTDIR\Code.exe,0"     
    WriteRegStr   HKCR                                                                                      \
                    "Directory\Background\shell\vscode\command"                                               \
                    ""                                                                                        \
                    '"$INSTDIR\Code.exe" "%V"'     

    ; ADD REGISTRY KEYS - ADD/REMOVE PROGRAMS
    ; Write information to registry so the program can be removed from the 'Add/Remove Programs' control panel
    WriteRegStr   HKLM                                                                                          \
                    "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPLICATION_NAME}($InstanceNumber)"  \
                    "DisplayIcon"                                                                               \
                    "$INSTDIR\code.exe"               
    WriteRegStr   HKLM                                                                                          \
                    "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPLICATION_NAME}($InstanceNumber)"  \
                    "DisplayName"                                                                               \
                    "${APPLICATION_NAME}"         
    WriteRegStr   HKLM                                                                                          \
                    "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPLICATION_NAME}($InstanceNumber)"  \
                    "DisplayVersion"                                                                            \
                    "${BUILD_LEVEL}"
    WriteRegDWORD HKLM                                                                                          \
                    "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPLICATION_NAME}($InstanceNumber)"  \
                    "EstimatedSize"                                                                             \
                    1259000
    WriteRegStr   HKLM                                                                                          \
                    "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPLICATION_NAME}($InstanceNumber)"  \
                    "InstallLocation"                                                                           \
                    "$INSTDIR"
    WriteRegDWORD HKLM                                                                                          \
                    "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPLICATION_NAME}($InstanceNumber)"  \
                    "NoModify"                                                                                  \
                    1
    WriteRegDWORD HKLM                                                                                          \
                    "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPLICATION_NAME}($InstanceNumber)"  \
                    "NoRepair"                                                                                  \
                    1
    WriteRegStr   HKLM                                                                                          \
                    "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPLICATION_NAME}($InstanceNumber)"  \
                    "Publisher"                                                                                 \
                    "Scott Meesseman"
    WriteRegStr   HKLM                                                                                          \
                    "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPLICATION_NAME}($InstanceNumber)"  \
                    "UninstallString"                                                                           \
                    "$INSTDIR\${UNINSTALL_FILE_NAME} $Delimiter$InstanceNumber$Delimiter"

    ; Set context to 'All Users'
    SetShellVarContext "all"

    ;Create uninstall file
    WriteUninstaller "$INSTDIR\${UNINSTALL_FILE_NAME}"

SectionEnd


;*********************************************************************
;*                                                                   *
;*   Section Definition                                              *
;*                                                                   * 
;*      Uninstall                                                    * 
;*                                                                   * 
;*********************************************************************

Section "Uninstall"

    ; Explicitly set the registry view to be 64 bits
    SetRegView 64

    ; Set context to 'All Users'
    ;SetShellVarContext "all"

    ; Extract instance information from the command line arg
   
   ; Define our delimiter
   StrCpy $Delimiter "#"

   ; Specify the amount of text to copy   
   StrCpy $Size 1

   ; Copy the command line
   StrCpy $CommandLine $CMDLINE

   ; Get the command line length
   StrLen $CommandLineLength $CMDLINE
   
   ; Set current offset
   StrCpy $CurrentOffset "0"
   
Param1Start:

    ; Increment the current offset
    IntOp $CurrentOffset $CurrentOffset + 1

    ; Bounds check
    IntCmp $CurrentOffset $CommandLineLength InvalidCommandLine 0 InvalidCommandLine

    ; Extract the character at the current offset
    StrCpy $CurrentValue $CommandLine $Size $CurrentOffset

    ; Check to see if we found our delimiter
    StrCmp $CurrentValue $Delimiter Param1StartFound Param1StartNotFound

Param1StartFound:

        ; Increment the current offset
        IntOp $CurrentOffset $CurrentOffset + 1

        ; Save the offset as the end
        StrCpy $InstanceNumberStart $CurrentOffset

        ; Go to the Param1End label
        goto Param1End

Param1StartNotFound:
        ; Go to the Param1Start label
        goto Param1Start
        
Param1End:

    ; Increment the current offset
    IntOp $CurrentOffset $CurrentOffset + 1

    ; Extract the character at the current offset
    StrCpy $CurrentValue $CommandLine $Size $CurrentOffset

    ; Check to see if we found our delimiter
    StrCmp $CurrentValue $Delimiter Param1EndFound Param1EndNotFound

Param1EndFound:

        ; Save the offset as the end
        StrCpy $InstanceNumberEnd $CurrentOffset

        ; Go to the FindComplete label
        goto Param1Complete

Param1EndNotFound:
        ; Go to the Param1End label
        goto Param1End

Param1Complete:

    ; Calculate the length
    IntOp $InstanceNumberLength $InstanceNumberEnd - $InstanceNumberStart

    ; Extract the instance name
    StrCpy $InstanceNumber $CommandLine $InstanceNumberLength $InstanceNumberStart

    ; GLOBAL NODE MODULES
    ExecWait '"$INSTDIR\install_node_modules.bat" uninstall'

    ; EXTENSIONS
    ExecWait '"$INSTDIR\install_extensions.bat" --uninstall-extension'
    RMDir /r "$PROFILE\.vscode\extensions"

    ; REMOVE LOCAL INSTALLATON DIRS FROM SETUP
    RMDir /r "$INSTDIR\ant"
    RMDir /r "$INSTDIR\ansicon"
    RMDir /r "$INSTDIR\compilers"
    RMDir /r "$INSTDIR\insiders"
    RMDir /r "$INSTDIR\gradle"
    RMDir /r "$INSTDIR\nodejs"
    RMDir /r "$INSTDIR\nsis"
    RMDir /r "$INSTDIR\python"
    RMDir /r "$INSTDIR\sdks"
    RMDir /r "$INSTDIR\bin"
    RMDir /r "$INSTDIR\locales"
    RMDir /r "$INSTDIR\resources"
    RMDir /r "$INSTDIR\tools"

    ; DELETE USER SETTINGS IF USER SAYS ITS OK
    MessageBox MB_YESNO "Delete user settings and cache?" IDYES true1 IDNO false1
    true1:
        ;RMDir /r "$INSTDIR\data"
        RMDir /r "$PROFILE\.vscode"
        RMDir /r "$APPDATA\Code"
    false1:

    ; uninstall vscode
    ; uninstaller for vscode exe installer
    ;ExecWait '"$INSTDIR\unins000.exe" /SILENT /SUPPRESSMSGBOXES'

    ; UNINSTALL GIT IF USER SAYS ITS OK
    ReadRegStr $R0 HKLM "SOFTWARE\GitForWindows" "InstallPath"  ; Check to see if already installed
    IfFileExists "$R0\bin\git.exe" 0 false0
    MessageBox MB_YESNO "Uninstall Git?" IDYES true0 IDNO false0
    true0:
        ExecWait '"$INSTDIR\git\unins000.exe" /SILENT /SUPPRESSMSGBOXES'
        RMDir /r "$INSTDIR\git"
    false0:

    ; UNINSTALL TORTOISESVN IF USER SAYS ITS OK
    ReadRegStr $R0 HKLM "SOFTWARE\TortoiseSVN" "Directory"  ; Check to see if already installed
    IfFileExists "$R0\bin\svn.exe" 0 false2
    MessageBox MB_YESNO "Uninstall Tortoise SVN?" IDYES true2 IDNO false2
    true2:
        ExecWait 'msiexec /x "$INSTDIR\TortoiseSVN-1.11.1.28492-x64-svn-1.11.1.msi" /passive REBOOT=ReallySuppress MSIRESTARTMANAGERCONTROL=Disable'
        RMDir /r "$INSTDIR\tortoisesvn"
    false2:

    ; UNINSTALL .NET472 DEV PACK
    IfFileExists "$INSTDIR\NDP472-DevPack.exe" 0 DEVPACK_UNINSTALLED
        ExecWait '"$INSTDIR\NDP472-DevPack.exe" /uninstall /passive /noreboot'
    DEVPACK_UNINSTALLED:

    Delete "$INSTDIR\*.*"

    ; REMOVE VARIABLES FROM PATH ENVIRONMENT VARIABLE
    Push "$INSTDIR\ant\bin"
    Call un.RemoveFromPath
    Push "$INSTDIR\gradle\bin"
    Call un.RemoveFromPath
    Push "$INSTDIR\python"
    Call un.RemoveFromPath
    Push "$INSTDIR\python\scripts"
    Call un.RemoveFromPath
    Push "$INSTDIR\nodejs"
    Call un.RemoveFromPath
    Push "$INSTDIR\nodejs\node_modules\typescript\bin"
    Call un.RemoveFromPath
    Push "$INSTDIR\bin"
    Call un.RemoveFromPath
    Push "$INSTDIR\nsis"
    Call un.RemoveFromPath
    ; REMOVE CUSTOM ENVIRONMENT VARIABLES
    ; TODO - This only sets var to empty string, want to delete var
    Push "ANT_HOME"
    Push "$INSTDIR\ant"
    Call un.RemoveFromEnvVar
    Push "CODE_HOME"
    Push "$INSTDIR"
    Call un.RemoveFromEnvVar
    Push "PYTHONPATH"
    Push "$INSTDIR\python;$INSTDIR\python\DLLs;$INSTDIR\python\lib;$INSTDIR\python\lib\plat-win;$INSTDIR\python\lib\site-packages;$INSTDIR\python\Scripts"
    Call un.RemoveFromEnvVar

    ; Delete the desktop shortcut
    Delete "$DESKTOP\Code.lnk"

    ; DELETE REGISTRY KEYS
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPLICATION_NAME}($InstanceNumber)"
    DeleteRegKey HKCR "*\shell\Open with VS Code"
    DeleteRegKey HKCR "Directory\shell\vscode"
    DeleteRegKey HKCR "Directory\Background\shell\vscode"

    ; THIS WILL ONLY REMOVE THE BASE DIR IF IT IS EMPTY
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

    ;SetRegView 64
    ;ReadRegStr $R0 HKLM \
    ;"Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPLICATION_NAME}" \
    ;"UninstallString"
    ;StrCmp $R0 "" done
    ;
    ;MessageBox MB_OKCANCEL|MB_ICONEXCLAMATION \
    ;"${APPLICATION_NAME} is already installed. $\n$\nClick `OK` to remove the \
    ;previous version or `Cancel` to cancel this upgrade." \
    ;IDOK uninst
    ;Abort
    ;
    ;;Run the uninstaller
    ;uninst:
    ;ClearErrors
    ;;Do not copy the uninstaller to a temp file
    ;ExecWait '$R0 _?=$INSTDIR'
    ;;Exec $R0 ; supposedly lets uninstaller remove itself
    ;IfErrors 0 done
    ;   ; need to delete uninstaller here?
    ;
    ;; TODO - a bug when running the installer after the uninstall none of the path vars
    ;; get registered.  Force user to re-run installer for now
    ;Abort
    ;
    ;done:
    
    ;Extract InstallOptions INI files
    !insertmacro MUI_INSTALLOPTIONS_EXTRACT "InstanceNumber.ini"

FunctionEnd

;*********************************************************************
;*                                                                   * 
;*      GetInstanceNumber                                            * 
;*                                                                   * 
;*********************************************************************

Function GetInstanceNumber

    !insertmacro MUI_HEADER_TEXT "Customization" "Instance Number"
    !insertmacro MUI_INSTALLOPTIONS_DISPLAY "InstanceNumber.ini"

    ;Read the value
    !insertmacro MUI_INSTALLOPTIONS_READ $InstanceNumber "InstanceNumber.ini" "Field 2" "State"

    ;Specify the default installation folder
    StrCpy $INSTDIR "C:\Code-$InstanceNumber"

FunctionEnd

;*********************************************************************
;*                                                                   * 
;*      InstTypePageCreate                                           * 
;*                                                                   * 
;*********************************************************************

Function InstTypePageCreate

    nsDialogs::Create 1018
    Pop $1

    !insertmacro MUI_HEADER_TEXT "Choose Installation Packages" \
            "Choose Installation Packages to Install" 

    ${If} $InstallInsiders == ""
        StrCpy $InstallInsiders YES
    ${EndIf}
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


    SetRegView 64

    ${NSD_CreateLabel} 0 10u 100% 10u "Choose Installation Packages"
    Pop $R8

    ${NSD_CreateCheckBox} 10u 30u 45% 10u "Visual Studio Code Insiders"
    Pop $2
    IfFileExists "$INSTDIR\insiders\Code - Insiders.exe" 0 insidersdone
        EnableWindow $2 0
        StrCpy $InstallInsiders NO
    insidersdone:
    ${If} $InstallInsiders == YES 
        ${NSD_Check} $2
    ${EndIf}

    ${NSD_CreateCheckBox} 10u 45u 45% 10u ".NET 4.72 Developer Pack"
    Pop $3
    IfFileExists "$INSTDIR\NDP472-DevPack.exe" 0 net472done
        EnableWindow $3 0
        StrCpy $InstallNet472DevPack NO
    net472done:
    ${If} $InstallNet472DevPack == YES 
        ${NSD_Check} $3
    ${EndIf}

    ${NSD_CreateCheckBox} 10u 60u 45% 10u "Tortoise SVN + Cmd Line Tools"
    Pop $4
    ReadRegStr $R0 HKLM "SOFTWARE\TortoiseSVN" "Directory"  ; Check to see if already installed
    IfFileExists "$R0\bin\svn.exe" 0 svndone
        EnableWindow $4 0
        StrCpy $InstallTortoise NO
    svndone:
    ${If} $InstallTortoise == YES 
        ${NSD_Check} $4
    ${EndIf}

    ${NSD_CreateCheckBox} 10u 75u 45% 10u "Git for Windows"
    Pop $5
    ReadRegStr $R0 HKLM "SOFTWARE\GitForWindows" "InstallPath"  ; Check to see if already installed
    IfFileExists "$R0\bin\git.exe" 0 gitdone
        EnableWindow $5 0
        StrCpy $InstallGit NO
    gitdone:
    ${If} $InstallGit == YES 
        ${NSD_Check} $5
    ${EndIf}

    ${NSD_CreateCheckBox} 10u 90u 45% 10u "Dotfuscator Community Edition"
    Pop $6
    IfFileExists "$INSTDIR\dotfuscator\ce\DotfuscatorCLI.exe" 0 dotfuscatordone
        EnableWindow $6 0
        StrCpy $InstallDotfuscator NO
    dotfuscatordone:
    ${If} $InstallDotfuscator == YES 
        ${NSD_Check} $6
    ${EndIf}

    ${NSD_CreateCheckBox} 145u 30u 45% 10u "Nullsoft Scriptable Installer (NSIS)"
    Pop $7
    IfFileExists "$INSTDIR\nsis\makensis.exe" 0 nsisdone
        EnableWindow $7 0
        StrCpy $InstallNsis NO
    nsisdone:
    ${If} $InstallNsis == YES 
        ${NSD_Check} $7
    ${EndIf}

    ${NSD_CreateCheckBox} 145u 45u 45% 10u "Python for Windows"
    Pop $8
    IfFileExists "$INSTDIR\python\scripts\pip.exe" 0 pythondone
        EnableWindow $8 0
        StrCpy $InstallPython NO
    pythondone:
    ${If} $InstallPython == YES 
        ${NSD_Check} $8
    ${EndIf}

    ${NSD_CreateCheckBox} 145u 60u 45% 10u ".NET SDKs"
    Pop $R1
    IfFileExists "$INSTDIR\sdks\atlmfc\lib\atl.lib" 0 netsdksdone
        EnableWindow $R1 0
        StrCpy $InstallNetSdks NO
    netsdksdone:
    ${If} $InstallNetSdks == YES 
        ${NSD_Check} $R1
    ${EndIf}

    ${NSD_CreateCheckBox} 145u 75u 45% 10u "Legacy SDKs"
    Pop $R2
    IfFileExists "$INSTDIR\sdks\atlmfc\lib\atl.lib" 0 legacysdksdone
        EnableWindow $R2 0
        StrCpy $InstallLegacySdks NO
    legacysdksdone:
    ${If} $InstallLegacySdks == YES 
        ${NSD_Check} $R2
    ${EndIf}

    ${NSD_CreateCheckBox} 145u 90u 45% 10u "Apache Ant"
    Pop $R3
    IfFileExists "$INSTDIR\ant\bin\ant.bat" 0 antdone
        EnableWindow $R3 0
        StrCpy $InstallAntAnsicon NO
    antdone:
    ${If} $InstallAntAnsicon == YES 
        ${NSD_Check} $R3
    ${EndIf}

    ${NSD_CreateCheckBox} 145u 105u 45% 10u "Gradle"
    Pop $R4
    IfFileExists "$INSTDIR\gradle\bin\gradle.bat" 0 gradledone
        EnableWindow $R4 0
        StrCpy $InstallGradle NO
    gradledone:
    ${If} $InstallGradle == YES 
        ${NSD_Check} $R4
    ${EndIf}

    ${NSD_CreateLabel} 0 130u 100% 10u "Visual Studio Code is installed by default"
    Pop $R9

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

    ${NSD_GetState} $2 $0
    ${If} $0 != ${BST_CHECKED}
        StrCpy $InstallInsiders NO
    ${Else}
        StrCpy $InstallInsiders YES
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

FunctionEnd
