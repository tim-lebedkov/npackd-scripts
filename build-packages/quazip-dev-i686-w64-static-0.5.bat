echo This script builds zlib using mingw-w64 for the 32 bit Windows statically

cd "%~dp0"

set name=QuaZIP-static-i686-w32-0.5

if exist %name% (
    echo The directory "%name%" already exists. Please delete it and restart this script
    goto :eof
)

"%npackd_cl%\npackdcl.exe" add --package=net.sourceforge.mingw-w64.MinGWW64 --version=1.0.2011.11.1
if %errorlevel% neq 0 exit /b %errorlevel%

"%npackd_cl%\npackdcl.exe" add --package=net.sourceforge.quazip.QuaZIPSource --version=0.5
if %errorlevel% neq 0 exit /b %errorlevel%

"%npackd_cl%\npackdcl.exe" add --package=com.nokia.QtSource --version=4.8.2
if %errorlevel% neq 0 exit /b %errorlevel%

set onecmd="%npackd_cl%\npackdcl.exe" path "--package=net.sourceforge.mingw-w64.MinGWW64" "--versions=[1.0.2011.11.1, 1.0.2011.11.1]"
for /f "usebackq delims=" %%x in (`%%onecmd%%`) do set mingww64=%%x

set onecmd="%npackd_cl%\npackdcl.exe" path "--package=net.sourceforge.quazip.QuaZIPSource" "--versions=[0.5, 0.5]"
for /f "usebackq delims=" %%x in (`%%onecmd%%`) do set quazipsource=%%x

set onecmd="%npackd_cl%\npackdcl.exe" path "--package=com.nokia.QtSource" "--versions=[4.8.2, 4.8.2]"
for /f "usebackq delims=" %%x in (`%%onecmd%%`) do set qtsource=%%x

xcopy "%quazipsource%" %name% /E /I /Q
if %errorlevel% neq 0 exit /b %errorlevel%

rem QuaZIP searches for -lz.dll...
copy zlib-i686-w32-1.2.5\libzdll.a zlib-i686-w32-1.2.5\libz.dll.a

set path=%mingww64%\bin
cd %name%
..\Qt-static-i686-w32-4.8.2\qmake\qmake.exe CONFIG+=staticlib CONFIG+=release INCLUDEPATH="%CD%\..\\zlib-i686-w32-1.2.5" LIBS+=-L"%CD%\\..\\zlib-i686-w32-1.2.5" LIBS+=-L"%CD%\quazip\\release"
if %errorlevel% neq 0 exit /b %errorlevel%
                    
"%mingww64%\bin\mingw32-make.exe"
if %errorlevel% neq 0 exit /b %errorlevel%

pause
