echo on

rem This script is used by AppVeyor automatic builds to install the necessary
rem software dependencies.

msiexec.exe /qn /i https://github.com/tim-lebedkov/npackd-cpp/releases/download/version_1.21.6/NpackdCL-1.21.6.msi
if %errorlevel% neq 0 exit /b %errorlevel%

SET NPACKD_CL=C:\Program Files (x86)\NpackdCL

"%npackd_cl%\ncl" add-repo --url=https://npackd.appspot.com/rep/recent-xml
if %errorlevel% neq 0 exit /b %errorlevel%

"%npackd_cl%\ncl" add-repo --url=https://npackd.appspot.com/rep/xml?tag=libs
if %errorlevel% neq 0 exit /b %errorlevel%

"%npackd_cl%\ncl" detect
if %errorlevel% neq 0 exit /b %errorlevel%

"%npackd_cl%\ncl" help
if %errorlevel% neq 0 exit /b %errorlevel%

"%npackd_cl%\ncl" set-install-dir -f "C:\Program Files (x86)"
if %errorlevel% neq 0 exit /b %errorlevel%

