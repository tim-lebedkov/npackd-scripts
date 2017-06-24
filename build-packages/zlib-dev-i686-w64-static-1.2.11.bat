set onecmd="%npackd_cl%\npackdcl.exe" path "--package=mingw-w64-i686-sjlj-posix" "--versions=[4.9.2, 4.9.2]"
for /f "usebackq delims=" %%x in (`%%onecmd%%`) do set mingww64=%%x

set onecmd="%npackd_cl%\npackdcl.exe" path "--package=net.zlib.ZLibSource" "--versions=[1.2.11, 1.2.11]"
for /f "usebackq delims=" %%x in (`%%onecmd%%`) do set zlibsource=%%x

xcopy "%zlibsource%" zlib-dev-i686-w64-static-1.2.11 /E /I /Q
if %errorlevel% neq 0 exit /b %errorlevel%

set path=%mingww64%\bin
cd zlib-dev-i686-w64-static-1.2.11
mingw32-make -f win32\Makefile.gcc
if %errorlevel% neq 0 exit /b %errorlevel%

pause
