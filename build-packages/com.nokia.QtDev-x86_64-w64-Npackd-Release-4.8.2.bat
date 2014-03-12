echo This script builds Qt using mingw-w64 for the 64 bit Windows

cd "%~dp0"

if exist qt (
    echo The directory "qt" already exists. Please delete it and restart this script
    rem goto :eof
)

set onecmd="%npackd_cl%\npackdcl.exe" path "--package=net.sourceforge.mingw-w64.MinGWW6464" "--versions=[1.0.2011.11.1, 1.0.2011.11.1]"
for /f "usebackq delims=" %%x in (`%%onecmd%%`) do set mingww6464=%%x

set onecmd="%npackd_cl%\npackdcl.exe" path "--package=com.nokia.QtSource" "--versions=[4.8.2, 4.8.2]"
for /f "usebackq delims=" %%x in (`%%onecmd%%`) do set qtsource=%%x

set onecmd="%npackd_cl%\npackdcl.exe" path "--package=com.activestate.ActivePerl64" "--versions=[5.14.2.1402, 5.14.2.1402]"
for /f "usebackq delims=" %%x in (`%%onecmd%%`) do set activeperl64=%%x

rem xcopy "%qtsource%" qt /E /I /Q /D:
if %errorlevel% neq 0 exit /b %errorlevel%

set path=%mingww6464%\bin;%activeperl64%\bin
cd qt
configure.bat -opensource -confirm-license -release -static -no-qt3support -no-opengl -no-dsp -no-vcproj -no-dbus -no-phonon -no-phonon-backend -no-multimedia -no-webkit -no-script -no-scripttools -no-declarative -nomake examples -nomake demos -nomake tests -no-style-plastique -no-style-cleanlooks -no-style-motif -no-style-cde -qt-style-windowsvista -qt-style-windowsxp
if %errorlevel% neq 0 exit /b %errorlevel%

gmake
if %errorlevel% neq 0 exit /b %errorlevel%

