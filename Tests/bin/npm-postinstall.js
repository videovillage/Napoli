// check os
async function run() {
  const process = require("process")
  var os = require("os")
  var platform = os.platform()

  let libraryName = process.argv.slice(2)
  let swiftBuildCommand = "swift build -c release"
  var moveLibraryCommand = ""
  let nodeHeadersVersion = "19.0.1"
  var downloadHeadersCommand = ""

  const util = require("util")
  const exec = require("node:child_process").exec

  if (platform == "darwin" || platform == "linux") {
    downloadHeadersCommand = `npx node-gyp install ${nodeHeadersVersion} --devdir=node_headers --ensure`
    var libExtension = platform == "darwin" ? ".dylib" : ".so"
    moveLibraryCommand = `mv .build/release/lib${libraryName}${libExtension} .build/release/${libraryName}.node`
  } else if (platform === "win32") {
    downloadHeadersCommand = `npx node-gyp install ${nodeHeadersVersion} --arch=x64 --devdir=node_headers --ensure`
    moveLibraryCommand = `move /Y .build\\release\\${libraryName}.dll .build\\release\\${libraryName}.node`
  } else {
    console.log("Unsupported platform: " + platform)
    process.exit(1)
  }

  try {
    console.log(`Downloading Node.js headers: \"${downloadHeadersCommand}\"`)
    var download = exec(downloadHeadersCommand)
    download.stdout.pipe(process.stdout)
    download.stderr.pipe(process.stderr)
    await new Promise((resolve) => {
      download.on("close", resolve)
    })

    console.log(`Build: \"${swiftBuildCommand}\"`)
    var build = exec(swiftBuildCommand)
    build.stdout.pipe(process.stdout)
    build.stderr.pipe(process.stderr)
    await new Promise((resolve) => {
      build.on("close", resolve)
    })

    console.log(`Renaming library to .node: \"${moveLibraryCommand}\"`)
    var move = exec(moveLibraryCommand)
    move.stdout.pipe(process.stdout)
    move.stderr.pipe(process.stderr)
    await new Promise((resolve) => {
      move.on("close", resolve)
    })
  } catch (e) {
    console.error(e)
    process.exit(1)
  }
}

run()
