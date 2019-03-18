
;*********************************************************************
;*                                                                   *
;*   Define                                                          *
;*                                                                   * 
;*********************************************************************

; Define application name
!define APPLICATION_NAME     "Code Package"

; Define build level
!define BUILD_LEVEL          "1.32.3.0"

; Define install file name
!define INSTALL_FILE_NAME    "CodePackageInstall64.exe"

; Define uninstall file name
!define UNINSTALL_FILE_NAME  "CodePackageUninstall.exe"

; Define MUI_ABORTWARNING so that a warning message is displayed
; if you attempt to cancel an install
!define MUI_ABORTWARNING

; Define MUI_HEADERPAGE to display a custom bitmap
!define MUI_ICON "code.ico"
!define MUI_HEADERIMAGE 
!define MUI_HEADERIMAGE_BITMAP "pja24bit.bmp"

; Set context to 'All Users'
!define ALL_USERS

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

;*********************************************************************
;*                                                                   *
;*   Variables                                                       *
;*                                                                   * 
;*********************************************************************


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
OutFile "..\${INSTALL_FILE_NAME}"

; Show details of install
ShowInstDetails show

; Show details of uninstall
ShowUninstDetails show

; Specify the pages to display when performing an Install
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

; Specify the pages to display when performing an Uninstall
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
  
; Specify the language
!insertmacro MUI_LANGUAGE "English"

; Reserve the files


;*********************************************************************
;*                                                                   *
;*   Section Definition                                              *
;*                                                                   *
;*      Install                                                      *
;*                                                                   *
;*********************************************************************

Section "Install"

   ; Explicitly set the registry view to be 64 bits
   SetRegView 64

   ; Specify the output path
   SetOutPath "$INSTDIR"
  
   ; Specify the files to extract
   File /r /x settings.json /x keybindings.json ..\build\*.*
   ;File /r ..\build\*.*

   ; Check if 'settings.json' exists in the target directory   
   IfFileExists data\user-data\User\settings.json SETTINGS_FILE_ALREADY_EXISTS 0

   ; Copy the file
   File /oname=data\user-data\User\settings.json ..\build\settings.json

   SETTINGS_FILE_ALREADY_EXISTS:

   ; Check if 'keybindings.json' exists in the target directory   
   IfFileExists $INSTDIR\data\user-data\User\keybindings.json KEYBINDINGS_FILE_ALREADY_EXISTS 0

   ; Copy the file
   File /oname=data\user-data\User\keybindings.json ..\build\keybindings.json

   KEYBINDINGS_FILE_ALREADY_EXISTS:

   MessageBox MB_YESNO "Install Tortoise SVN?" IDYES true0 IDNO false0
   true0:
     ExecWait 'msiexec /i "$INSTDIR\TortoiseSVN-1.11.1.28492-x64-svn-1.11.1.msi" /passive /norestart INSTALLDIR="$INSTDIR\tortoisesvn" ADDLOCAL=ALL'
   false0:
   
   ;ExecWait '"$INSTDIR\VSCodeSetup.exe" /SILENT /MERGETASKS="!runcode,addcontextmenufiles,addcontextmenufolders,associatewithfiles" /NORESTART /NOCANCEL /DIR="$INSTDIR"'

   ; Extensions
   ExecWait '"$INSTDIR\install_extensions.bat" --install-extension'
   ; ExecWait '"$INSTDIR\enable_extensions_api.bat"'

   ; Add 'johnstoncode.svn-scm' to enabledProposedApi list
   ; < v 1.32
   Push '$INSTDIR\resources\app\product.json'
   Push '"ms-vsliveshare.vsliveshare"]'
   Push '"ms-vsliveshare.vsliveshare", "johnstoncode.svn-scm"]'
   Call ReplaceInFile
   ; >= V 1.32
   Push '$INSTDIR\resources\app\product.json'
   Push '"atlassian.atlascode"]'
   Push '"atlassian.atlascode", "johnstoncode.svn-scm"]'
   Call ReplaceInFile

   ; Node modules
   ; ExecWait 'cmd.exe "$INSTDIR\nodejs\npm" install -g eslint'
   ExecWait '"$INSTDIR\install_node_modules.bat" install'

   ; Custom files copy/move
   ExecWait '"$INSTDIR\copy_settings.bat"'

   NSISdl::download https://go.microsoft.com/fwlink/?LinkId=874338 "$INSTDIR\NDP472-DevPack.exe"

   ; .NET 4.72 development pack
   ExecWait '"$INSTDIR\NDP472-DevPack.exe" /passive /noreboot'
   
      ; Add to PATH
   Push "$INSTDIR\ant\bin"
   Call AddToPath

   Push "$INSTDIR\nodejs"
   Call AddToPath

   Push "$INSTDIR\nsis"
   Call AddToPath

   Push "$INSTDIR\nodejs\node_modules\typescript\bin"
   Call AddToPath

   Push "$INSTDIR\bin"
   Call AddToPath
   
   ; Add to environment
   Push "ANT_HOME"
   Push "$INSTDIR\ant"
   Call AddToEnvVar
   
   Push "CODE_HOME"
   Push "$INSTDIR"
   Call AddToEnvVar
   
   ;Registry

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

   ; Write information to registry so the program can be removed from
   ; the 'Add/Remove Programs' control panel applet.

   WriteRegStr   HKLM                                                                                        \
                 "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPLICATION_NAME}"                   \
                 "DisplayIcon"                                                                               \
                 "$INSTDIR\code.exe"               
 
   WriteRegStr   HKLM                                                                                        \
                 "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPLICATION_NAME}"                   \
                 "DisplayName"                                                                               \
                 "${APPLICATION_NAME}"
                
   WriteRegStr   HKLM                                                                                        \
                 "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPLICATION_NAME}"                   \
                 "DisplayVersion"                                                                            \
                 "${BUILD_LEVEL}"

   WriteRegDWORD HKLM                                                                                        \
                 "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPLICATION_NAME}"                   \
                 "EstimatedSize"                                                                             \
                 1259000

   WriteRegStr   HKLM                                                                                        \
                 "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPLICATION_NAME}"                   \
                 "InstallLocation"                                                                           \
                 "$INSTDIR"

   WriteRegDWORD HKLM                                                                                        \
                 "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPLICATION_NAME}"                   \
                 "NoModify"                                                                                  \
                 1

   WriteRegDWORD HKLM                                                                                        \
                 "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPLICATION_NAME}"                   \
                 "NoRepair"                                                                                  \
                 1

   WriteRegStr   HKLM                                                                                        \
                 "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPLICATION_NAME}"                   \
                 "Publisher"                                                                                 \
                 "Perry Johnson & Associates"

   WriteRegStr   HKLM                                                                                        \
                 "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPLICATION_NAME}"                   \
                 "UninstallString"                                                                           \
                 "$INSTDIR\${UNINSTALL_FILE_NAME}"

   ; Set context to 'All Users'
   SetShellVarContext "all"

   ; Create Desktop shortcut
   CreateShortCut "$DESKTOP\Code.lnk" \
                  "$INSTDIR\code.exe"

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

   ExecWait '"$INSTDIR\NDP472-DevPack.exe" /uninstall /passive /noreboot'
   
   ;ExecWait '"$INSTDIR\nodejs\npm" uninstall -g jshint'
   ; ExecWait '"$INSTDIR\install_jshint.bat" uninstall'
   ExecWait '"$INSTDIR\install_node_modules.bat" uninstall'
   
   ExecWait '"$INSTDIR\install_extensions.bat" --uninstall-extension'

   RMDir /r "$INSTDIR\data\extensions"
   RMDir /r "$INSTDIR\ant"
   RMDir /r "$INSTDIR\ansicon"
   RMDir /r "$INSTDIR\compilers"
   RMDir /r "$INSTDIR\nodejs"
   RMDir /r "$INSTDIR\nsis"
   RMDir /r "$INSTDIR\sdks"

   RMDir /r "$INSTDIR\bin"
   RMDir /r "$INSTDIR\locales"
   RMDir /r "$INSTDIR\resources"
   RMDir /r "$INSTDIR\tools"
   Delete "$INSTDIR\*.*"

   MessageBox MB_YESNO "Delete user settings?" IDYES true1 IDNO false1
   true1:
     RMDir /r "$INSTDIR\data"
   false1:
   
   MessageBox MB_YESNO "Uninstall Tortoise SVN?" IDYES true2 IDNO false2
   true2:
     ExecWait 'msiexec /x "$INSTDIR\TortoiseSVN-1.11.1.28492-x64-svn-1.11.1.msi" /passive REBOOT=ReallySuppress MSIRESTARTMANAGERCONTROL=Disable'
     RMDir /r "$INSTDIR\tortoisesvn"
   false2:
 
   ;ExecWait '"$INSTDIR\unins000.exe" /SILENT'

   Push "$INSTDIR\ant\bin"
   Call un.RemoveFromPath

   Push "$INSTDIR\nodejs"
   Call un.RemoveFromPath

   Push "$INSTDIR\nodejs\node_modules\typescript\bin"
   Call un.RemoveFromPath

   Push "$INSTDIR\bin"
   Call un.RemoveFromPath
   
   Push "$INSTDIR\nsis"
   Call un.RemoveFromPath

   Push "ANT_HOME"
   Push "$INSTDIR\ant"
   Call un.RemoveFromEnvVar
   
   Push "CODE_HOME"
   Push "$INSTDIR"
   Call un.RemoveFromEnvVar
   
   ; Delete the desktop shortcut
   Delete "$DESKTOP\Code.lnk"

   ; Delete Uninstall registry key information
   DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPLICATION_NAME}"

   DeleteRegKey HKCR "*\shell\Open with VS Code"
   DeleteRegKey HKCR "Directory\shell\vscode"
   DeleteRegKey HKCR "Directory\Background\shell\vscode"

   RMDir "$INSTDIR"

SectionEnd


;*********************************************************************
;*                                                                   *
;*   Function Definition                                             *
;*                                                                   * 
;*      .onInit                                                      * 
;*                                                                   * 
;*********************************************************************

Function .onInit

   ; Specify default directory
   StrCpy $INSTDIR "c:\Code"

FunctionEnd

