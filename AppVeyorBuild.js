Array.prototype.contains = function(v) {
    for (var i = 0; i < this.length; i++) {
        if (this[i] == v)
            return true;
    }
    return false;
}

// http://stackoverflow.com/questions/6274339/how-can-i-shuffle-an-array-in-javascript
function shuffle(array) {
    var counter = array.length, temp, index;

    // While there are elements in the array
    while (counter > 0) {
        // Pick a random index
        index = Math.floor(Math.random() * counter);

        // Decrease counter by 1
        counter--;

        // And swap the last element with it
        temp = array[counter];
        array[counter] = array[index];
        array[index] = temp;
    }

    return array;
}

function exec(cmd) {
    var result = exec2("cmd.exe /s /c \"" + cmd + " 2>&1\"");
    return result[0];
}

function execSafe(cmd) {
    var result = exec2("cmd.exe /s /c \"" + cmd + " 2>&1\"");
    var ec = result[0];
    if (ec !== 0)
        throw new Error(cmd + " failed with the exit code " + ec);
}

/**
 * @param npackdcl "...\ncl.exe"
 * @param package_ full package name
 * @param version version number
 * @return path to the specified package or "" if not installed
 */
function getPath(npackdcl, package_, version) {
    var res = exec2("cmd.exe /c \"" + npackdcl + "\" path -p " + package_ +
            " -v " + version + " 2>&1");
    var lines = res[1];
    if (lines.length > 0)
        return lines[0];
    else
        return "";
}

/**
 * @param npackdcl "...\ncl.exe"
 * @param package_ full package name
 * @param versions range of versions
 * @param require true = install if necessary
 * @return path to the specified package or "" if not installed
 */
function getPathR(npackdcl, package_, versions, require) {
    var res = exec2("cmd.exe /s /c \"\"" + npackdcl + "\" path " +
            " -r \"" + versions + "\" -p " + package_ + " 2>&1\"");
    if (res[1].length > 0)
        return res[1][0];
    else {
		execSafe("\"" + npackdcl + "\" add " +
				" -r \"" + versions + "\" -p " + package_);

		res = exec2("cmd.exe /s /c \"\"" + npackdcl + "\" path " +
            " -r \"" + versions + "\" -p " + package_ + " 2>&1\"");
		if (res[1].length > 0)
			return res[1][0];
		else
			return "";
	}
}

/**
 * Executes the specified command, prints its output on the default output.
 *
 * @param cmd this command should be executed
 * @return [exit code, [output line 1, output line2, ...]]
 */
function exec2(cmd) {
    WScript.Echo(cmd);
    var shell = WScript.CreateObject("WScript.Shell");
    var p = shell.exec(cmd);
    var output = [];
    while (!p.StdOut.AtEndOfStream) {
        var line = p.StdOut.ReadLine();
        WScript.Echo(line);
        output.push(line);
    }

    return [p.ExitCode, output];
}

/**
 * @param a first version as a String
 * @param b first version as a String
 */
function compareVersions(a, b) {
	a = a.split(".");
	b = b.split(".");
	
	var len = Math.max(a.length, b.length);
	
	var r = 0;
	
	for (var i = 0; i < len; i++) {
		var ai = 0;
		var bi = 0;
		
		if (i < a.length)
			ai = parseInt(a[i]);
		if (i < b.length)
			bi = parseInt(b[i]);

		// WScript.Echo("comparing " + ai + " and " + bi);
		
		if (ai < bi) {
			r = -1;
			break;
		} else if (ai > bi) {
			r = 1;
			break;
		}
	}
	
	return r;
}

function process() {
    var arguments = WScript.Arguments;
    var WshShell = WScript.CreateObject("WScript.Shell");
    var WshSysEnv = WshShell.Environment("Process");

    var package_ = WshSysEnv("PACKAGE");
    var version = WshSysEnv("VERSION");

    var npackdcl = "ncl.exe";

    var mingwVersion = "4.9.2";
	var compilerPackage = "mingw-w64-i686-sjlj-posix";
	if (package_ === "quazip-dev-i686-w64_sjlj_posix_4.9.2-qt_5.5-static") {
        source = "net.sourceforge.quazip.QuaZIPSource";
    } else if (package_ === "quazip-dev-i686-w64_sjlj_posix_7.1-qt_5.5-static") {
        source = "net.sourceforge.quazip.QuaZIPSource";
        mingwVersion = "7.1";
    } else if (package_ === "com.nokia.QtDev-i686-w64-Npackd-Release") {
        source = "com.nokia.QtSource";
        //mingwVersion = "7.2";
	} else if (package_ === "com.nokia.QtDev-x86_64-w64-Npackd-Release") {
        source = "com.nokia.QtSource";
		compilerPackage = "mingw-w64-x86_64-seh-posix";
        //mingwVersion = "7.2";
	} else if (package_ === "z-dev-i686-w64_sjlj_posix_4.9.2-static") {
        source = "net.zlib.ZLibSource";
	} else {
		throw new Error("Unsupported package");
	}
    
    var sevenzip = getPathR(npackdcl, "org.7-zip.SevenZIP", "[9,20)", true);

    execSafe("\"" + npackdcl + "\" add -p " + compilerPackage + " -v " + 
            mingwVersion);
			
    var mingw = getPath(npackdcl, compilerPackage, mingwVersion);
    
    execSafe("\"" + npackdcl + "\" add -p " + source + " -v " + version);
    
    var sourced = getPath(npackdcl, source, version);
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	if (!fso.FolderExists("build")) {
		execSafe("mkdir build");
		execSafe("mkdir build\\lib");
		execSafe("mkdir build\\include");
		execSafe("xcopy \"" + sourced + "\" build\\src /E /I /Q");
	}
    if (package_ === "quazip-dev-i686-w64_sjlj_posix_4.9.2-qt_5.5-static" ||
            package_ === "quazip-dev-i686-w64_sjlj_posix_7.1-qt_5.5-static") {
        execSafe("\"" + npackdcl + 
                "\" add -p com.nokia.QtDev-i686-w64-Npackd-Release -v 5.5");
        execSafe("\"" + npackdcl + 
                "\" add -p z-dev-i686-w64_sjlj_posix_4.9.2-static -v 1.2.11 --file=C:\\projects\\z-dev-i686-w64_sjlj_posix_4.9.2-static");
        var libz = getPath(npackdcl, "z-dev-i686-w64_sjlj_posix_4.9.2-static", "1.2.11");

        execSafe("set path=" + mingw + 
                "\\bin&&cd build\\src&&" +
                "C:\\NpackdSymlinks\\" +
                "com.nokia.QtDev-i686-w64-Npackd-Release-5.5\\qtbase\\" +
                "bin\\qmake.exe " +
                "LIBS+=-lz " +
                "LIBS+=-L\"" + libz + "\\lib\" " +
                "CONFIG+=staticlib CONFIG+=release DEFINES+=QUAZIP_STATIC");
        execSafe("set path=" + mingw + 
                "\\bin&&cd build\\src&&mingw32-make");
                
        execSafe("copy build\\src\\quazip\\release\\libquazip.a build\\lib");
        execSafe("copy build\\src\\quazip\\*.h build\\include");
    } else if (package_ === "com.nokia.QtDev-i686-w64-Npackd-Release" ||
			package_ === "com.nokia.QtDev-x86_64-w64-Npackd-Release") {
        var perl = getPathR(npackdcl, "com.activestate.ActivePerl64", "[5.8,6)");
        var python = getPathR(npackdcl, "org.python.Python64", "[2.7,4)");

        execSafe("xcopy \"" + sourced + 
                "\" C:\\NpackdSymlinks\\" + package_ + "-" + 
                version + " /E /I /Q");
				
		if (package_ === "com.nokia.QtDev-i686-w64-Npackd-Release" && 
				version === "5.5.1") {
			execSafe("bin\\patch C:\\NpackdSymlinks\\" + package_ + "-" + 
                version + "\\qtdeclarative\\src\\3rdparty\\masm\\yarr\\" + 
				"YarrPattern.h Qt-5.5.1-YarrPattern.h.patch");
		}
        
        // maybe use -ltcg
        execSafe("set path=" + mingw + 
                "\\bin&&cd C:\\NpackdSymlinks\\" + package_ + "-" + version + "&&call configure.bat -opensource -confirm-license -release -static -static-runtime -no-angle -no-dbus -nomake tools -nomake examples -nomake tests -no-compile-examples -no-incredibuild-xge -no-libproxy -no-qml-debug -no-style-fusion -qt-style-windowsvista -qt-style-windowsxp -platform win32-g++ -qt-zlib -qt-pcre -qt-libpng -qt-libjpeg -qt-freetype -opengl desktop -qt-sql-sqlite -no-openssl -make libs");
        execSafe("set path=" + mingw + 
                "\\bin;" + perl + "\\bin;" + python + "&&cd C:\\NpackdSymlinks\\" + package_ + "-" + 
                version + "&&mingw32-make");
    } else {
        execSafe("set path=" + mingw + 
                "\\bin&&cd build\\src&&mingw32-make -f win32\\Makefile.gcc");
                
        execSafe("copy build\\src\\libz.a build\\lib");
        execSafe("copy build\\src\\*.h build\\include");
    }
    
    execSafe("\"" + sevenzip + "\\7z\" a " + package_ + "-" + version + 
            ".zip .\\build\\* -mx9");
    
    execSafe("appveyor PushArtifact " + package_ + "-" + version + ".zip");
}

try {
    process();
} catch (e) {
    WScript.Echo(e.number + " " + e.description);
    WScript.Quit(1);
}

