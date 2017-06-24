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
    var result = exec2("cmd.exe /c " + cmd + " 2>&1");
    return result[0];
}

function execSafe(cmd) {
    var result = exec2("cmd.exe /c " + cmd + " 2>&1");
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
 * @return path to the specified package or "" if not installed
 */
function getPathR(npackdcl, package_, versions) {
    var res = exec2("cmd.exe /c \"" + npackdcl + "\" path -p " + package_ +
            " -r \"" + versions + "\" 2>&1");
    var lines = res[1];
    if (lines.length > 0)
        return lines[0];
    else
        return "";
}

/**
 * Executes the specified command, prints its output on the default output.
 *
 * @param cmd this command should be executed
 * @return [exit code, [output line 1, output line2, ...]]
 */
function exec2(cmd) {
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
    var package_ = "zlib-dev-i686-w64_4.9.2-static";
    var version = "1.2.11";

    execSafe("\"" + npackdcl + "\" detect");

    var npackdcl = "C:\\Program Files (x86)\\NpackdCL\\ncl.exe";

    execSafe("\"" + npackdcl + "\" help");
    execSafe("\"" + npackdcl + "\" add -p mingw-w64-i686-sjlj-posix -v 4.9.2");
    execSafe("\"" + npackdcl + "\" add -p org.7-zip.SevenZIP -r \"[9,20)\"");
    execSafe("\"" + npackdcl + "\" add -p net.zlib.ZLibSource -v " + version);
    
    var mingw = getPath(npackdcl, "mingw-w64-i686-sjlj-posix", "4.9.2");
    var zlibsource = getPath(npackdcl, "net.zlib.ZLibSource", version);
    var sevenzip = getPathR(npackdcl, "org.7-zip.SevenZIP", "[9,20)");
    
    execSafe("xcopy " + zlibsource + " build /E /I /Q");
    
    execSafe("set path=" + mingw + 
            "\\bin&&cd build&&mingw32-make -f win32\\Makefile.gcc");
    
    execSafe("\"" + sevenzip + "\\7z\" a ..\\" + package_ + "-" + version + 
            ".zip * -mx9");
    
    execSafe("appveyor PushArtifact %package%-%version%.zip");
}

try {
    process();
} catch (e) {
    WScript.Echo(e.number + " " + e.description);
    WScript.Quit(1);
}

