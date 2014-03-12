echo This script builds Qt using mingw-w64 for the 64 bit Windows

cd "%~dp0"

set qt_version=4.8.2
set mingww64_version=4.7.2
set activeperl_version=5.14.2.1402

set dest=C:\Libs\com.nokia.QtDev-i686-w64-Npackd-%qt_version%

mkdir %dest%

if exist %dest% (
    echo The directory %dest% already exists. Please delete it and restart this script
    goto :eof
)

set onecmd="%npackd_cl%\npackdcl.exe" path "--package=net.sourceforge.mingw-w64.MinGWW64" "--versions=[%mingww64_version%, %mingww64_version%]"
for /f "usebackq delims=" %%x in (`%%onecmd%%`) do set mingww64=%%x

set onecmd="%npackd_cl%\npackdcl.exe" path "--package=com.nokia.QtSource" "--versions=[%qt_version%, %qt_version%]"
for /f "usebackq delims=" %%x in (`%%onecmd%%`) do set qtsource=%%x

set onecmd="%npackd_cl%\npackdcl.exe" path "--package=com.activestate.ActivePerl64" "--versions=[%activeperl_version%, %activeperl_version%]"
for /f "usebackq delims=" %%x in (`%%onecmd%%`) do set activeperl64=%%x

xcopy "%qtsource%" %dest% /E /I /Q
if %errorlevel% neq 0 exit /b %errorlevel%

set path=%mingww64%\bin;%activeperl64%\bin
cd %dest%
configure.exe -opensource -confirm-license -release -static -no-qt3support -no-opengl -no-dsp -no-vcproj -no-dbus -no-phonon -no-phonon-backend -no-multimedia -no-webkit -no-script -no-scripttools -no-declarative -nomake examples -nomake demos -nomake tests -no-style-plastique -no-style-cleanlooks -no-style-motif -no-style-cde -qt-style-windowsvista -qt-style-windowsxp
if %errorlevel% neq 0 exit /b %errorlevel%

gmake
if %errorlevel% neq 0 exit /b %errorlevel%

