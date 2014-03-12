set onecmd="%npackd_cl%\npackdcl.exe" path "--package=mingw-w64-x86_64-seh-posix" "--versions=[4.8.2, 4.8.2]"
for /f "usebackq delims=" %%x in (`%%onecmd%%`) do set mingww64=%%x

set onecmd="%npackd_cl%\npackdcl.exe" path "--package=net.zlib.ZLibSource" "--versions=[1.2.8, 1.2.8]"
for /f "usebackq delims=" %%x in (`%%onecmd%%`) do set zlibsource=%%x

xcopy "%zlibsource%" zlib32static /E /I /Q

set path=%mingww64%\bin
cd zlib32static
mingw32-make.exe -f win32\Makefile.gcc

pause
