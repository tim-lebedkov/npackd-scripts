rem install MinGW-w64
"%npackd_cl%\ncl" add -p mingw-w64-i686-sjlj-posix -v 4.9.2
if %errorlevel% neq 0 exit /b %errorlevel%

rem find MinGW-w64
set onecmd="%npackd_cl%\npackdcl.exe" path "--package=mingw-w64-i686-sjlj-posix" "--versions=[4.9.2, 4.9.2]"
for /f "usebackq delims=" %%x in (`%%onecmd%%`) do set mingww64=%%x

rem install MinGW-w64
"%npackd_cl%\ncl" add -p net.zlib.ZLibSource -v 1.2.11
if %errorlevel% neq 0 exit /b %errorlevel%

rem find ZLibSource
set onecmd="%npackd_cl%\npackdcl.exe" path "--package=net.zlib.ZLibSource" "--versions=[1.2.11, 1.2.11]"
for /f "usebackq delims=" %%x in (`%%onecmd%%`) do set zlibsource=%%x

xcopy "%zlibsource%" zlib-dev-i686-w64-static-1.2.11 /E /I /Q
if %errorlevel% neq 0 exit /b %errorlevel%

set path=%mingww64%\bin
cd zlib-dev-i686-w64-static-1.2.11
mingw32-make -f win32\Makefile.gcc
if %errorlevel% neq 0 exit /b %errorlevel%

appveyor PushArtifact zlib.zip
if %errorlevel% neq 0 exit /b %errorlevel%
