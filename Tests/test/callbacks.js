/* eslint-env mocha */

const assert = require("assert")
const addon = require("../")

describe("Callbacks:", function () {
  it("runs threadsafe callbacks", function (done) {
    addon.runThreadsafeCallback(function (msg) {
      assert.strictEqual(msg, "hello world")
      done()
      return "message"
    })
  })

  it("runs typed callbacks", () => {
    addon.takeTypedCallback(function (number, bool) {
      assert.strictEqual(number, 23)
      assert.strictEqual(bool, true)
      return `${number}${bool}`
    })
  })

  it("returns successful promise", async function () {
    const promise = addon.returnSuccessfulPromise("cool")
    assert.strictEqual(await promise, "cool hello")
    assert.strictEqual(await promise, "cool hello")
  })

  it("returns throwing promise", async function () {
    await assert.rejects(addon.returnThrowingPromise("cool"), (err) => {
      assert.strictEqual(err.code, "ETEST")
      assert.strictEqual(err.message, "Error message")
      return true
    })
  })

  it("takes successful promise", async function () {
    await addon.takeSuccessfulPromise(Promise.resolve("cool I did it!"))
  })

  it("takes throwing promise", async function () {
    await addon.takeThrowingPromise(Promise.reject(new Error("lol sorry")))
  })
})
