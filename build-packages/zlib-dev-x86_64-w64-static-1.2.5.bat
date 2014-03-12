"%npackd_cl%\npackdcl.exe" add --package=net.sourceforge.mingw-w64.MinGWW64 --version=1.0.2011.11.1
if %errorlevel% neq 0 exit /b %errorlevel%

"%npackd_cl%\npackdcl.exe" add --package=net.zlib.ZLibSource --version=1.2.5
if %errorlevel% neq 0 exit /b %errorlevel%

set onecmd="%npackd_cl%\npackdcl.exe" path "--package=net.sourceforge.mingw-w64.MinGWW64" "--versions=[1.0.2011.11.1, 1.0.2011.11.1]"
for /f "usebackq delims=" %%x in (`%%onecmd%%`) do set mingww64=%%x

set onecmd="%npackd_cl%\npackdcl.exe" path "--package=net.zlib.ZLibSource" "--versions=[1.2.5, 1.2.5]"
for /f "usebackq delims=" %%x in (`%%onecmd%%`) do set zlibsource=%%x

xcopy "%zlibsource%" zlib32static /E /I /Q
if %errorlevel% neq 0 exit /b %errorlevel%

set path=%mingww64%\bin
cd zlib32static
gmake -f win32\Makefile.gcc
if %errorlevel% neq 0 exit /b %errorlevel%

pause
