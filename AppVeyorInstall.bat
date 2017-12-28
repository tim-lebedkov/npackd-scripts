echo on

rem This script is used by AppVeyor automatic builds to install the necessary
rem software dependencies.

msiexec.exe /qn /i https://github.com/tim-lebedkov/npackd-cpp/releases/download/version_1.23.2/NpackdCL-1.23.2.msi
if %errorlevel% neq 0 exit /b %errorlevel%

set path=C:\ProgramData\Npackd\Commands;C:\Program Files (x86)\NpackdCL;C:\Windows\System32

ncl add-repo --url=https://npackd.appspot.com/rep/recent-xml
if %errorlevel% neq 0 exit /b %errorlevel%

ncl add-repo --url=https://npackd.appspot.com/rep/xml?tag=libs
if %errorlevel% neq 0 exit /b %errorlevel%

ncl detect
if %errorlevel% neq 0 exit /b %errorlevel%

ncl help
if %errorlevel% neq 0 exit /b %errorlevel%

ncl set-install-dir -f "C:\Program Files (x86)"
if %errorlevel% neq 0 exit /b %errorlevel%

