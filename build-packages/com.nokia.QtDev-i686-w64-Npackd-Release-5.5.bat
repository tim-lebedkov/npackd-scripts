set name=com.nokia.QtDev-i686-w64-Npackd-Release-5.5

set onecmd="%npackd_cl%\npackdcl.exe" path "--package=mingw-w64-i686-sjlj-posix" "--versions=[4.9.2, 4.9.2]"
for /f "usebackq delims=" %%x in (`%%onecmd%%`) do set mingww6464=%%x

set onecmd="%npackd_cl%\npackdcl.exe" path "--package=com.nokia.QtSource" "--versions=[5.5, 5.5]"
for /f "usebackq delims=" %%x in (`%%onecmd%%`) do set qtsource=%%x

set onecmd="%npackd_cl%\npackdcl.exe" path "--package=com.activestate.ActivePerl64" "--versions=[5.8, 6)"
for /f "usebackq delims=" %%x in (`%%onecmd%%`) do set activeperl64=%%x

set onecmd="%npackd_cl%\npackdcl.exe" path "--package=org.python.Python64" "--versions=[2.7, 4)"
for /f "usebackq delims=" %%x in (`%%onecmd%%`) do set python64=%%x

xcopy "%qtsource%" C:\NpackdSymlinks\%name% /E /I /Q /D
if %errorlevel% neq 0 exit /b %errorlevel%

cd C:\NpackdSymlinks\%name%
set path=%mingww6464%\bin;%activeperl64%\bin;%python64%
cd %name%
rem maybe use -ltcg
rem -no-make tests does not seems to be available
call configure.bat -opensource -confirm-license -release -static -static-runtime -no-angle -no-dbus -nomake tools -nomake examples -nomake tests -no-compile-examples -no-incredibuild-xge -no-libproxy -no-qml-debug -no-style-fusion -qt-style-windowsvista -qt-style-windowsxp -platform win32-g++ -qt-zlib -qt-pcre -qt-libpng -qt-libjpeg -qt-freetype -opengl desktop -qt-sql-sqlite -no-openssl -make libs
if %errorlevel% neq 0 exit /b %errorlevel%

rem mingw-w64-i686-sjlj-posix 4.8.2 requires a patch in lib\gcc\i686-w64-mingw32\4.8.2\include\xmmintrin.h:
rem
rem #ifdef __cplusplus
rem extern "C" {
rem #endif
rem
rem ..........     
rem
rem #ifdef __cplusplus
rem }
rem #endif
rem ------------------------------------------------------------------------------

mingw32-make.exe
if %errorlevel% neq 0 exit /b %errorlevel%

