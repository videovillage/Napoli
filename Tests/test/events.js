/* eslint-env mocha */

const addon = require("../")
const assert = require("assert")
const { EventEmitter } = require("events")

describe("EventEmitter", () => {
  it("can emit events synchronously", async () => {
    await new Promise((resolve, reject) => {
      let emitter = new EventEmitter()
      emitter.once("channel5", (value1, value2) => {
        assert.strictEqual(value1, "hello from swiftland")
        assert.strictEqual(value2, "hello from swiftland2")
        resolve()
      })
      addon.emitOnEventEmitter(emitter)
    })
  })

  it("can emit events asynchronously", async () => {
    await new Promise(async (resolve, reject) => {
      let emitter = new EventEmitter()
      emitter.once("channel11", (value1) => {
        assert.strictEqual(value1, "hello from swiftland async")
        resolve()
      })
      await addon.emitOnEventEmitterAsync(emitter)
    })
  })

  it("can receive emitted events", async () => {
    let emitter = new EventEmitter()
    let promise = addon.receiveOnEventEmitter(emitter, () => {
      emitter.emit("channel23Async", 22, "test", { a: 1, b: 2 })
    })

    await promise
  })
})
