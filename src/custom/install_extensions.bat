
@echo off

echo Command: %1
if "%1" == "" ( exit )

rem if "%1" == "--install-extension" (
rem     "%~pd0\bin\code" %1 johnstoncode.svn-scm --force %1 svn-scm-ext-0.0.1.vsix --force %1 momoto.binary-viewer --force %1 ms-vscode.cpptools --force %1 ms-vscode.csharp --force %1 dbaeumer.vscode-eslint --force %1 pkief.material-icon-theme --force %1 idleberg.nsis --force %1 ms-vscode.powershell --force %1 ms-mssql.mssql --force %1 dotjoshjohnson.xml --force %1 lkytal.quicktask --force %1 sanaajani.taskrunnercode --force %1 msjsdiag.debugger-for-chrome --force %1 msjsdiag.debugger-for-edge --force %1 ms-vscode.vscode-typescript-tslint-plugin --force %1 eg2.vscode-npm-script --force %1 christian-kohler.npm-intellisense --force 
rem )
rem else (
    "%~pd0\bin\code" %1 johnstoncode.svn-scm --force %1 spmeesseman.svn-scm-ext --force %1 momoto.binary-viewer --force %1 ms-vscode.cpptools --force %1 ms-vscode.csharp --force %1 dbaeumer.vscode-eslint --force %1 pkief.material-icon-theme --force %1 idleberg.nsis --force %1 ms-vscode.powershell --force %1 ms-mssql.mssql --force %1 dotjoshjohnson.xml --force %1 lkytal.quicktask --force %1 sanaajani.taskrunnercode --force %1 msjsdiag.debugger-for-chrome --force %1 msjsdiag.debugger-for-edge --force %1 ms-vscode.vscode-typescript-tslint-plugin --force %1 eg2.vscode-npm-script --force %1 christian-kohler.npm-intellisense --force %1 davidanson.vscode-markdownlint --force 
rem )

