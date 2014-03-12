set name=com.nokia.QtDev-x86_64-w64-Npackd-Release-5.2.1 

set onecmd="%npackd_cl%\npackdcl.exe" path "--package=mingw-w64-x86_64-seh-posix" "--versions=[4.8.2, 4.8.2]"
for /f "usebackq delims=" %%x in (`%%onecmd%%`) do set mingww6464=%%x

set onecmd="%npackd_cl%\npackdcl.exe" path "--package=com.nokia.QtSource" "--versions=[5.2.1, 5.2.1]"
for /f "usebackq delims=" %%x in (`%%onecmd%%`) do set qtsource=%%x

set onecmd="%npackd_cl%\npackdcl.exe" path "--package=com.activestate.ActivePerl64" "--versions=[5.16.3.1603, 5.16.3.1603]"
for /f "usebackq delims=" %%x in (`%%onecmd%%`) do set activeperl64=%%x

set onecmd="%npackd_cl%\npackdcl.exe" path "--package=org.python.Python64" "--versions=[3.3.4, 3.3.4]"
for /f "usebackq delims=" %%x in (`%%onecmd%%`) do set python64=%%x

xcopy "%qtsource%" C:\NpackdSymlinks\%name% /E /I /Q /D
if %errorlevel% neq 0 exit /b %errorlevel%

cd C:\NpackdSymlinks\%name%
set path=%mingww6464%\bin;%activeperl64%\bin;%python64%
cd %name%
call configure.bat -opensource -confirm-license -release -static -no-angle -no-vcproj -no-dbus -nomake tools -nomake examples -nomake tests -no-style-fusion -qt-style-windowsvista -qt-style-windowsxp -platform win32-g++ -qt-zlib -qt-pcre -qt-libpng -qt-libjpeg -qt-freetype -opengl desktop -qt-sql-sqlite -no-openssl -make libs
if %errorlevel% neq 0 exit /b %errorlevel%

mingw32-make.exe
if %errorlevel% neq 0 exit /b %errorlevel%

rem mingw32-make.exe clean
rem if %errorlevel% neq 0 exit /b %errorlevel%

