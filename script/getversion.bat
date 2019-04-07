@echo off
..\build\nodejs\node -e "console.log(require('../package.json').version);"
