echo This script builds msi using mingw-w64 for the 32 bit Windows

"%npackd_cl%\npackdcl.exe" add --package=net.sourceforge.mingw-w64.MinGWW64 --version=1.0.2011.11.1
if %errorlevel% neq 0 exit /b %errorlevel%

set onecmd="%npackd_cl%\npackdcl.exe" path "--package=net.sourceforge.mingw-w64.MinGWW64" "--versions=[1.0.2011.11.1, 1.0.2011.11.1]"
for /f "usebackq delims=" %%x in (`%%onecmd%%`) do set mingww64=%%x

mkdir MSI-i686-w32-5
if %errorlevel% neq 0 exit /b %errorlevel%

"%mingww64%\bin\gendef" C:\Windows\SysWOW64\msi.dll
if %errorlevel% neq 0 exit /b %errorlevel%

"%mingww64%\bin\dlltool" -D C:\Windows\SysWOW64\msi.dll -V -l libmsi.a
if %errorlevel% neq 0 exit /b %errorlevel%

pause
