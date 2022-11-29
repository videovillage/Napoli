/* eslint-env mocha */

const assert = require("assert")
const addon = require("../")

const expectedJSON = global.JSON.parse(
  `{"testString":"testString","optionalString2":null,"nested":{"nestedTestString":"nestedTestString"},"optionalNested":null,"optionalString":"optionalTestString"}`
)

describe("Environment", () => {
  it("works with environment", () => {
    assert.deepEqual(global.JSON.parse(addon.testEnvironment()), expectedJSON)
  })

  it("works with environment async", async () => {
    assert.deepEqual(
      global.JSON.parse(await addon.testEnvironmentAsync()),
      expectedJSON
    )
  })
})
