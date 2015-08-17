set onecmd="%npackd_cl%\npackdcl.exe" path "--package=mingw-w64-x86_64-seh-posix" "--versions=[4.8.2, 4.8.2]"
for /f "usebackq delims=" %%x in (`%%onecmd%%`) do set mingww64=%%x

set onecmd="%npackd_cl%\npackdcl.exe" path "--package=org.xapian.XapianCore" "--versions=[1.2.18, 1.2.18]"
for /f "usebackq delims=" %%x in (`%%onecmd%%`) do set xapiansource=%%x

xcopy "%xapiansource%" xapian-dev-x86_64-w64-1.2.18 /E /I /Q

set path=%mingww64%\bin;C:\MinGW\msys\1.0\bin
cd xapian-dev-x86_64-w64-1.2.18
bash ./configure
mingw32-make.exe

pause

