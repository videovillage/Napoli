#!/usr/bin/env node

// check os
async function run() {
  var os = require("os")
  var platform = os.platform()

  var swiftBuildCommand = ""
  var moveLibraryCommand = ""

  if (platform == "darwin" || platform == "linux") {
    swiftBuildCommand =
      "swift build -c release -Xlinker -undefined -Xlinker dynamic_lookup"
    var libExtension = platform == "darwin" ? ".dylib" : ".so"
    moveLibraryCommand =
      "mv .build/release/libNapoliTests" +
      libExtension +
      " .build/release/NapoliTests.node"
  } else if (platform === "win32") {
  } else {
    console.log("Unsupported platform: " + platform)
    process.exit(1)
  }

  // run a shell script without exec
  const util = require("util")
  const { runInContext } = require("vm")
  const exec = util.promisify(require("child_process").exec)

  try {
    await exec(swiftBuildCommand)
  } catch (e) {
    console.error(e)
  }
}

run()
