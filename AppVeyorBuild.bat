echo on

rem This script is used by AppVeyor to build the project.

where appveyor

set path=C:\ProgramData\Npackd\Commands;C:\Program Files (x86)\NpackdCL;C:\Program Files\AppVeyor\BuildAgent;C:\Windows\System32

cscript AppVeyorBuild.js

