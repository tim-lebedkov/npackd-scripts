# This is the build file for quazip-dev-i686-w64-static

# QuaZIP version that should be build
VERSION=0.6.2

# ------------------------------------------------------------------------------

RPAREN=)
NAME=quazip-dev-i686-w64-static-$(VERSION)
WHERE=$(NAME)
QT=C:\NpackdSymlinks\com.nokia.QtDev-i686-w64-Npackd-Release-5.2.1
QUAZIP=$(shell "%npackd_cl%\npackdcl.exe" path "--package=net.sourceforge.quazip.QuaZIPSource" "--versions=[0.6.2, 0.6.2]")
MINGW=$(shell "%npackd_cl%\npackdcl.exe" "path" "--package=mingw-w64-i686-sjlj-posix" "--versions=[4.8.2, 4.8.2]")

$(WHERE)\quazip\release\libquazip.a: $(WHERE)\Makefile
	set path=$(MINGW)\bin&& cd $(WHERE) && mingw32-make.exe

$(WHERE)\Makefile: $(WHERE)
	set path=$(MINGW)\bin&& cd $(WHERE) && $(QT)\qtbase\bin\qmake.exe CONFIG+=staticlib CONFIG+=release

# INCLUDEPATH=%zlib% LIBS+=-L%zlib% LIBS+=-lz

$(WHERE): 
	xcopy "$(QUAZIP)" $(WHERE) /E /I /Q /D

