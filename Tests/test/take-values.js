/* eslint-env mocha */

const addon = require("../")
const assert = require("assert")

describe("Take Values", () => {
  it("takes strings", () => {
    addon.takeString("a string")
  })

  it("takes doubles", () => {
    addon.takeDouble(1337)
  })

  it("takes booleans", () => {
    addon.takeBoolean(true)
  })

  it("takes arrayBuffer", () => {
    var array = new Uint8Array([12, 44, 35, 10])
    addon.takeArrayBuffer(array.buffer)
  })

  it("takes dates", () => {
    const date = new Date(1000)
    addon.takeDate(date)
  })

  it("takes null", () => {
    addon.takeNull(null)
  })

  it("takes undefined", () => {
    addon.takeUndefined(undefined)
  })

  it("takes error", () => {
    var error = new Error("a message")
    error.code = "neat code"
    addon.takeError(error)
  })

  describe("Errors", () => {
    it("expects strings", () => {
      assert.throws(
        () => addon.takeString(1337),
        (err) => err.message === "stringExpected"
      )
      assert.throws(
        () => addon.takeString(true),
        (err) => err.message === "stringExpected"
      )
      assert.throws(
        () => addon.takeString(null),
        (err) => err.message === "stringExpected"
      )
      assert.throws(
        () => addon.takeString(undefined),
        (err) => err.message === "stringExpected"
      )
    })

    it("expects doubles", () => {
      assert.throws(
        () => addon.takeDouble("a string"),
        (err) => err.message === "numberExpected"
      )
      assert.throws(
        () => addon.takeDouble(true),
        (err) => err.message === "numberExpected"
      )
      assert.throws(
        () => addon.takeDouble(null),
        (err) => err.message === "numberExpected"
      )
      assert.throws(
        () => addon.takeDouble(undefined),
        (err) => err.message === "numberExpected"
      )
    })

    it("expects booleans", () => {
      assert.throws(
        () => addon.takeBoolean("a string"),
        (err) => err.message === "booleanExpected"
      )
      assert.throws(
        () => addon.takeBoolean(1337),
        (err) => err.message === "booleanExpected"
      )
      assert.throws(
        () => addon.takeBoolean(null),
        (err) => err.message === "booleanExpected"
      )
      assert.throws(
        () => addon.takeBoolean(undefined),
        (err) => err.message === "booleanExpected"
      )
    })

    it("expects null", () => {
      assert.throws(
        () => addon.takeNull("a string"),
        (err) => err.message === "nullExpected"
      )
      assert.throws(
        () => addon.takeNull(1337),
        (err) => err.message === "nullExpected"
      )
      assert.throws(
        () => addon.takeNull(true),
        (err) => err.message === "nullExpected"
      )
      assert.throws(
        () => addon.takeNull(undefined),
        (err) => err.message === "nullExpected"
      )
    })

    it("expects undefined", () => {
      assert.throws(
        () => addon.takeUndefined("a string"),
        (err) => err.message === "undefinedExpected"
      )
      assert.throws(
        () => addon.takeUndefined(1337),
        (err) => err.message === "undefinedExpected"
      )
      assert.throws(
        () => addon.takeUndefined(true),
        (err) => err.message === "undefinedExpected"
      )
      assert.throws(
        () => addon.takeUndefined(null),
        (err) => err.message === "undefinedExpected"
      )
    })
  })
})
