/* eslint-env mocha */

const assert = require("assert")
const addon = require("../")

describe("Errors", () => {
  it("throws an error", () => {
    assert.throws(
      () => addon.throwError(),
      (err) => {
        return err.message === "Error message" && err.code === "ETEST"
      }
    )
  })

  it("throws an error when calling with more args than expected", () => {
    assert.throws(
      () => addon.takeString("an", "error"),
      (err) => {
        assert.strictEqual(err.code, "ESWIFTCALLBACK")
        assert.strictEqual(
          err.message,
          "Received invalid arg count (actual: 2, expected: 1)"
        )
        return true
      }
    )
  })
})
