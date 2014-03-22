# This is the build file for com.nokia.QtDev-i686-w64-Npackd-Release

# Qt version that should be build
VERSION=5.2.1

# mingw-w64-i686-sjlj-posix 4.8.2 requires a patch in lib\gcc\i686-w64-mingw32\4.8.2\include\xmmintrin.h:
#
# #ifdef __cplusplus
# extern "C" {
# #endif
#
# ..........     
#
# #ifdef __cplusplus
# }
# #endif
# ------------------------------------------------------------------------------

RPAREN=)
NAME=com.nokia.QtDev-i686-w64-Npackd-Release-$(VERSION)
WHERE=C:\NpackdSymlinks\$(NAME)
QT=$(shell "%npackd_cl%\npackdcl.exe" "path" "--package=com.nokia.QtSource" "--versions=[$(VERSION), $(VERSION)]")
MINGW=$(shell "%npackd_cl%\npackdcl.exe" "path" "--package=mingw-w64-i686-sjlj-posix" "--versions=[4.8.2, 4.8.2]")
ACTIVEPERL=$(shell "%npackd_cl%\npackdcl.exe" "path" "--package=com.activestate.ActivePerl64" "--versions=[5.16.3.1603, 5.16.3.1603]")
PYTHON=$(shell "%npackd_cl%\npackdcl.exe" "path" "--package=org.python.Python64" "--versions=[3.3.4, 3.3.4]")

$(WHERE)\qtbase\lib\libQt5Gui.a: C:\NpackdSymlinks\$(NAME)\Makefile
	set path=$(MINGW)\bin;$(ACTIVEPERL)\bin;$(PYTHON)&& cd C:\NpackdSymlinks\$(NAME) && mingw32-make.exe

$(WHERE)\Makefile: C:\NpackdSymlinks\$(NAME)
	set path=$(MINGW)\bin;$(ACTIVEPERL)\bin;$(PYTHON)&& cd C:\NpackdSymlinks\$(NAME) && call configure.bat -opensource -confirm-license -release -static -no-angle -no-vcproj -no-dbus -nomake tools -nomake examples -nomake tests -no-style-fusion -qt-style-windowsvista -qt-style-windowsxp -platform win32-g++ -qt-zlib -qt-pcre -qt-libpng -qt-libjpeg -qt-freetype -opengl desktop -qt-sql-sqlite -no-openssl -make libs

$(WHERE): 
	xcopy "$(QT)" C:\NpackdSymlinks\$(NAME) /E /I /Q /D

