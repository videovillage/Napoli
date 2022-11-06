/* eslint-env mocha */

const addon = require("../")
const assert = require("assert")

describe("Pass by reference", () => {
  it("modifies objects", async () => {
    let anon = { cool: "bad" }
    await addon.modifyObjectByReference(anon)

    assert.equal(anon.cool, "neat")
    assert.equal(anon.additional, "good")
  })
})
