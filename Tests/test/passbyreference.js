/* eslint-env mocha */

const addon = require("../")
const assert = require("assert")

describe("Pass by reference", () => {
  it("modifies objects safely asynchronously", async () => {
    let anon = { cool: "bad" }
    await addon.modifyObjectByReferenceAsync(anon)

    assert.equal(anon.cool, "neat")
    assert.equal(anon.additional, "good")
  })

  it("modifies objects syncronously", () => {
    let anon = { cool: "bad" }
    addon.modifyObjectByReferenceSync(anon)

    assert.equal(anon.cool, "neat")
    assert.equal(anon.additional, "good")
  })
})
