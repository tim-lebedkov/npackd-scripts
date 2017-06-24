set w64ver=4.9.2

rem install MinGW-w64
"%npackd_cl%\ncl" add -p mingw-w64-i686-sjlj-posix -v %w64ver%
if %errorlevel% neq 0 exit /b %errorlevel%

rem find MinGW-w64
set onecmd="%npackd_cl%\npackdcl.exe" path "--package=mingw-w64-i686-sjlj-posix" "--versions=[%w64ver%, %w64ver%]"
for /f "usebackq delims=" %%x in (`%%onecmd%%`) do set mingww64=%%x

rem install 7-zip
"%npackd_cl%\ncl" add -p org.7-zip.SevenZIP -r "[9,20)"
if %errorlevel% neq 0 exit /b %errorlevel%

rem find 7-zip
set onecmd="%npackd_cl%\npackdcl.exe" path "--package=org.7-zip.SevenZIP" "--versions=[9, 20)"
for /f "usebackq delims=" %%x in (`%%onecmd%%`) do set sevenzip=%%x

rem install MinGW-w64
"%npackd_cl%\ncl" add -p net.zlib.ZLibSource -v %version%
if %errorlevel% neq 0 exit /b %errorlevel%

rem find ZLibSource
set onecmd="%npackd_cl%\npackdcl.exe" path "--package=net.zlib.ZLibSource" "--versions=[%version%, %version%]"
for /f "usebackq delims=" %%x in (`%%onecmd%%`) do set zlibsource=%%x

xcopy "%zlibsource%" build /E /I /Q
if %errorlevel% neq 0 exit /b %errorlevel%

set oldpath=%path%
set path=%mingww64%\bin

cd build

mingw32-make -f win32\Makefile.gcc
if %errorlevel% neq 0 exit /b %errorlevel%

"%sevenzip%\7z" a ..\%package%-%version%.zip * -mx9
if %errorlevel% neq 0 exit /b %errorlevel%

cd ..

set path=%oldpath%
appveyor PushArtifact %package%-%version%.zip
if %errorlevel% neq 0 exit /b %errorlevel%
