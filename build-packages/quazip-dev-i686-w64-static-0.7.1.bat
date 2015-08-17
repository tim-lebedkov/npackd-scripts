set name=quazip-dev-i686-w64-static-0.7.1

set onecmd="%npackd_cl%\npackdcl.exe" path "--package=mingw-w64-i686-sjlj-posix" "--versions=[4.9.2, 4.9.2]"
for /f "usebackq delims=" %%x in (`%%onecmd%%`) do set mingww64=%%x

set onecmd="%npackd_cl%\npackdcl.exe" path "--package=net.sourceforge.quazip.QuaZIPSource" "--versions=[0.7.1, 0.7.1]"
for /f "usebackq delims=" %%x in (`%%onecmd%%`) do set quazipsource=%%x

set qt=C:\NpackdSymlinks\com.nokia.QtDev-i686-w64-Npackd-Release-5.5
xcopy "%quazipsource%" %name% /E /I /Q

set zlib=C:\windows-package-manager.npackd-scripts\build-packages\zlib32static

set path=%mingww64%\bin
cd %name%
%qt%\qtbase\bin\qmake.exe CONFIG+=staticlib CONFIG+=release

"%mingww64%\bin\mingw32-make.exe"

