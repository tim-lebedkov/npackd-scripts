rem This script transfers the 5 default repositories from 
rem http://npackd.appspot.com
rem to the Git source repository at
rem https://github.com/tim-lebedkov/npackd
rem
rem The 5 repositories are:
rem http://npackd.appspot.com/rep/xml?tag=stable
rem http://npackd.appspot.com/rep/xml?tag=stable64
rem http://npackd.appspot.com/rep/xml?tag=libs 
rem http://npackd.appspot.com/rep/xml?tag=unstable
rem http://npackd.appspot.com/rep/xml?tag=vim
rem You would require commit permission for the Git repository.

set onecmd="%npackd_cl%\npackdcl.exe" path --package=org.xmlsoft.LibXML --versions=[2.4.12,2.4.12]
for /f "usebackq delims=" %%x in (`%%onecmd%%`) do set libxml=%%x

set onecmd="%npackd_cl%\npackdcl.exe" path --package=com.googlecode.msysgit.MSysGit --versions=[1.7,2)
for /f "usebackq delims=" %%x in (`%%onecmd%%`) do set git=%%x

set onecmd="%npackd_cl%\npackdcl.exe" path --package=se.haxx.curl.CURL64 --versions=[7,10)
for /f "usebackq delims=" %%x in (`%%onecmd%%`) do set curl=%%x
if "%curl%" == "" goto error

set onecmd="%npackd_cl%\npackdcl.exe" path --package=org.mingw.MSYS --versions=[2011,2020)
for /f "usebackq delims=" %%x in (`%%onecmd%%`) do set msys=%%x
if "%curl%" == "" goto error

set d=%temp%\%random%
mkdir %d%
if %errorlevel% neq 0 goto error

set /p user=Please enter your Github.com user name (e.g. black.smith): 
if "%user%" equ "" pause & goto :eof
if %errorlevel% neq 0 goto error

"%git%\bin\git.exe" clone https://github.com/tim-lebedkov/npackd.git "%d%"
if %errorlevel% neq 0 goto error

"%curl%\bin\curl.exe" -o "%d%\repository\Rep.xml" http://npackd.appspot.com/rep/xml?tag=stable
if %errorlevel% neq 0 goto error

"%curl%\bin\curl.exe" -o "%d%\repository\Rep64.xml" http://npackd.appspot.com/rep/xml?tag=stable64
if %errorlevel% neq 0 goto error

"%curl%\bin\curl.exe" -o "%d%\repository\Libs.xml" http://npackd.appspot.com/rep/xml?tag=libs 
if %errorlevel% neq 0 goto error

"%curl%\bin\curl.exe" -o "%d%\repository\RepUnstable.xml" http://npackd.appspot.com/rep/xml?tag=unstable
if %errorlevel% neq 0 goto error

"%curl%\bin\curl.exe" -o "%d%\repository\Vim.xml" http://npackd.appspot.com/rep/xml?tag=vim
if %errorlevel% neq 0 goto error

"%msys%\bin\unix2dos" "%d%\repository\Rep.xml" "%d%\repository\Rep64.xml" "%d%\repository\Libs.xml" "%d%\repository\RepUnstable.xml" "%d%\repository\Vim.xml"
if %errorlevel% neq 0 goto error

"%libxml%\bin\xmllint.exe" --noout "%d%\repository\Rep.xml"
if %errorlevel% neq 0 goto error

"%libxml%\bin\xmllint.exe" --noout "%d%\repository\Rep64.xml"
if %errorlevel% neq 0 goto error

"%libxml%\bin\xmllint.exe" --noout "%d%\repository\Libs.xml"
if %errorlevel% neq 0 goto error

"%libxml%\bin\xmllint.exe" --noout "%d%\repository\Vim.xml"
if %errorlevel% neq 0 goto error

pushd %d%

"%git%\bin\git.exe" commit -a -m "Updates from npackd.appspot.com"
if %errorlevel% neq 0 goto error

"%git%\bin\git.exe" push
if %errorlevel% neq 0 goto error

popd

rem removing the temporary directory
if "%d%" neq "" rmdir /s /q "%d%"

@echo ============================ SUCCESS =====================================
pause
goto :eof

:error
rem removing the temporary directory
if "%d%" neq "" rmdir /s /q "%d%"

@echo ============================ ERROR =======================================
pause

