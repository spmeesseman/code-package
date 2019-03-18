
The src folder contains the following SVN external:

    svn-scm

This external points to the johnstoncode-svn-scm extension project on GitHub.  

The current revision used is 983, tagged as Version 1.47.1

To prepare a fresh import and compile the extension for a Code release, run the 
following commands:

    cd c:\Projects\Code\src\svn-scm
    npm install

Copy the contents of the package.json file from src/custom/svn-scm.package.json 
to the src/svn-scm/package.json file.  This file contains the customization added
(additional items in File Explorer context menu).

Run the following svn-scm npm build script targets:

    posinstall
    compile
    build

Run the following command from a terminal:

    vsce package

A file called svn-scm-1.x.x.vsix will be created, which is included in the Code
Package installer.  Copy it to the custom folder:

    cp .\svn-scm-1.47.1.vsix ..\custom\
