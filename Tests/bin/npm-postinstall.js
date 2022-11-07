// check os
async function run() {
  const process = require("process")
  var os = require("os")
  var platform = os.platform()

  var swiftBuildCommand = ""
  var moveLibraryCommand = ""
  let nodeHeadersVersion = "19.0.1"
  var downloadHeadersCommand = ""

  const util = require("util")
  const exec = util.promisify(require("node:child_process").exec)
  var shell = ""

  if (platform == "darwin" || platform == "linux") {
    downloadHeadersCommand = `npx node-gyp install ${nodeHeadersVersion} --devdir=node_headers --ensure`
    shell = "/bin/sh"
    swiftBuildCommand = "swift build -c release"
    var libExtension = platform == "darwin" ? ".dylib" : ".so"
    moveLibraryCommand = `mv .build/release/libNapoliTests${libExtension} .build/release/NapoliTests.node`
  } else if (platform === "win32") {
    shell = "C:\\Program Files\\PowerShell\\7\\pwsh.EXE"
    downloadHeadersCommand = `npx.cmd node-gyp install ${nodeHeadersVersion} --arch=x64 --devdir=node_headers --ensure`
    swiftBuildCommand = "swift.exe build -c release"
    moveLibraryCommand =
      "Move-Item -Force -Path .build\\release\\NapoliTests.dll -Destination .build\\release\\NapoliTests.node"
  } else {
    console.log("Unsupported platform: " + platform)
    process.exit(1)
  }

  try {
    console.log(`Downloading Node.js headers: \"${downloadHeadersCommand}\"`)
    await exec(downloadHeadersCommand, { shell: shell })
    console.log(`Build: \"${swiftBuildCommand}\"`)
    await exec(swiftBuildCommand, { shell: shell })
    console.log(`Renaming library to .node: \"${moveLibraryCommand}\"`)
    await exec(moveLibraryCommand, { shell: shell })
  } catch (e) {
    console.error(e)
    process.exit(1)
  }
}

run()
