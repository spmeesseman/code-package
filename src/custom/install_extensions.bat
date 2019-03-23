
@echo off

echo Command: %1
if "%1" == "" ( exit )

"%~pd0\bin\code" %1 spmeesseman.svn-scm-ext --force \
                %1 beaugust.blamer-vs --force \
                %1 christian-kohler.npm-intellisense --force \
                %1 davidanson.vscode-markdownlint --force \
                %1 dbaeumer.vscode-eslint --force \
                %1 donjayamanne.githistory --force \
                %1 dotjoshjohnson.xml --force \
                %1 eamodio.gitlens --force \
                %1 eg2.vscode-npm-script --force \
                %1 hookyqr.beautify --force \
                %1 idleberg.nsis --force \
                %1 johnstoncode.svn-scm --force \
                %1 lkytal.quicktask --force \
                %1 momoto.binary-viewer --force \
                %1 ms-vscode.azure-account --force \
                %1 ms-azuretools.vscode-azureappservice --force \
                %1 ms-azuretools.vscode-azurestorage --force \
                %1 ms-mssql.mssql --force \
                %1 ms-vscode.cpptools --force \
                %1 ms-vscode.csharp --force \
                %1 ms-vscode.powershell --force \
                %1 ms-vscode.vscode-typescript-tslint-plugin --force \
                %1 msjsdiag.debugger-for-chrome --force \
                %1 msjsdiag.debugger-for-edge --force \
                %1 pkief.material-icon-theme --force \
                %1 sanaajani.taskrunnercode --force
