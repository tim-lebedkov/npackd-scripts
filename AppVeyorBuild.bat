echo on

rem This script is used by AppVeyor to build the project.

SET NPACKD_CL=C:\Program Files (x86)\NpackdCL

cd build-packages
call %package%-%version%.bat

