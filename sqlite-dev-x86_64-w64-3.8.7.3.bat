set onecmd="%npackd_cl%\npackdcl.exe" path "--package=mingw-w64-x86_64-seh-posix" "--versions=[4.8.2, 4.8.2]"
for /f "usebackq delims=" %%x in (`%%onecmd%%`) do set mingww64=%%x

set onecmd="%npackd_cl%\npackdcl.exe" path "--package=sqlite-source" "--versions=[3.8.7.3, 3.8.7.3]"
for /f "usebackq delims=" %%x in (`%%onecmd%%`) do set sqlitesource=%%x

xcopy "%sqlitesource%" sqlite-dev-x86_64-w64-3.8.7.3 /E /I /Q

set path=%mingww64%\bin;C:\MinGW\msys\1.0\bin
cd sqlite-dev-x86_64-w64-3.8.7.3
gcc -c sqlite3.c -o sqlite3.o -lpthread -ldl
ar rcs libsqlite3.a sqlite3.o
pause

