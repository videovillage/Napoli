/* eslint-env mocha */

const addon = require("../")
const assert = require("assert")
const { EventEmitter } = require("events")

describe("EventEmitter", () => {
  it("handles event emitters synchronously", async () => {
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

  it("handles event emitters asynchronously", async () => {
    await new Promise(async (resolve, reject) => {
      let emitter = new EventEmitter()
      emitter.once("channel11", (value1) => {
        assert.strictEqual(value1, "hello from swiftland async")
        resolve()
      })
      await addon.emitOnEventEmitterAsync(emitter)
    })
  })
})
