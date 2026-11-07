/* eslint-env mocha */

const assert = require("assert")
const { spawnSync } = require("node:child_process")
const path = require("node:path")

describe("Threadsafe function cleanup", function () {
  this.timeout(60000)

  it("releases callbacks from Swift executors while registering more on the JS thread", () => {
    const child = spawnSync(
      process.execPath,
      [
        "-e",
        `require("./").stressThreadsafeCleanup(2000).then(() => console.log("completed"))`,
      ],
      { cwd: path.resolve(__dirname, ".."), timeout: 45000, encoding: "utf8" }
    )
    assert.ifError(child.error)
    assert.strictEqual(child.signal, null, child.stderr)
    assert.strictEqual(child.status, 0, child.stderr)
    assert.match(child.stdout, /completed/)
  })
})
