function ensureExecSuccess(code) {
  if (code !== 0) {
    console.error(`Command failed with exit code ${code}`)
    process.exit(1)
  }
}

async function run() {
  const process = require("process")
  var os = require("os")
  var platform = os.platform()

  var libraryName = process.argv.slice(2)
  var swiftBuildCommand = "swift build -c release"
  var moveLibraryCommand = ""
  var nodeHeadersVersion = "33.0.2"
  var downloadHeadersCommand = ""

  const exec = require("node:child_process").exec

  if (platform == "darwin" || platform == "linux") {
    downloadHeadersCommand = `npx node-gyp install ${nodeHeadersVersion} --devdir=node_headers --dist-url=https://electronjs.org/headers --ensure`
    var libExtension = platform == "darwin" ? ".dylib" : ".so"
    moveLibraryCommand = `mv .build/release/lib${libraryName}${libExtension} .build/release/${libraryName}.node`
  } else if (platform === "win32") {
    downloadHeadersCommand = `npx node-gyp install ${nodeHeadersVersion} --arch=x64 --devdir=node_headers --dist-url=https://electronjs.org/headers --ensure`
    moveLibraryCommand = `move /Y .build\\release\\${libraryName}.dll .build\\release\\${libraryName}.node`
    swiftBuildCommand = `${swiftBuildCommand} -Xlinker -Lnode_headers\\${nodeHeadersVersion}\\x64`
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

    ensureExecSuccess(download.exitCode)

    console.log(`Build: \"${swiftBuildCommand}\"`)
    var build = exec(swiftBuildCommand)
    build.stdout.pipe(process.stdout)
    build.stderr.pipe(process.stderr)
    await new Promise((resolve) => {
      build.on("close", resolve)
    })

    ensureExecSuccess(build.exitCode)

    console.log(`Renaming library to .node: \"${moveLibraryCommand}\"`)
    var move = exec(moveLibraryCommand)
    move.stdout.pipe(process.stdout)
    move.stderr.pipe(process.stderr)
    await new Promise((resolve) => {
      move.on("close", resolve)
    })

    ensureExecSuccess(move.exitCode)
  } catch (e) {
    console.error(e)
    process.exit(1)
  }
}

run()
