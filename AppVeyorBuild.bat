echo on

rem This script is used by AppVeyor to build the project.

set path=C:\ProgramData\Npackd\Commands;C:\Program Files (x86)\NpackdCL;C:\Windows\System32

cscript AppVeyorBuild.js

