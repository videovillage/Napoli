/* eslint-env mocha */

const assert = require("assert")
const addon = require("../")

describe("Classes", () => {
  it("creates classes", () => {
    const testObject = new addon.TestClass1()
    assert.strictEqual(testObject.testString, "Cool")
  })

  it("creates classes with get/set properties", () => {
    const object = new addon.TestClass1()
    const other = new addon.TestClass1()

    assert.strictEqual(object.testString, "Cool")
    object.testString = "Changed"
    assert.doesNotThrow(() => object.assertTestString("Changed"))
    assert.strictEqual(object.testString, "Changed")

    assert.strictEqual(object.testNumber, 1234)
    object.testNumber = 4567
    assert.doesNotThrow(() => object.assertTestNumber(4567))
    assert.strictEqual(object.testNumber, 4567)

    assert.strictEqual(object.testObject.testString, "testString")
    assert.strictEqual(object.testObject.optionalString, "optionalTestString")
    assert.strictEqual(object.testObject.optionalString2, undefined)
    assert.strictEqual(
      object.testObject.nested.nestedTestString,
      "nestedTestString"
    )
    assert.strictEqual(object.testObject.optionalNested, undefined)

    const changedTestObject = object.testObject
    changedTestObject.testString = "replacementTestString"
    changedTestObject.nested.nestedTestString = "replacementNestedTestString"
    changedTestObject.optionalNested = {
      nestedTestString: "replacementOptionalNestedTestString",
    }
    changedTestObject.optionalString2 = "replacementOptionalString2"

    object.testObject = changedTestObject

    assert.strictEqual(object.testObject.testString, "replacementTestString")
    assert.strictEqual(
      object.testObject.optionalString2,
      "replacementOptionalString2"
    )
    assert.strictEqual(
      object.testObject.nested.nestedTestString,
      "replacementNestedTestString"
    )
    assert.strictEqual(
      object.testObject.optionalNested.nestedTestString,
      "replacementOptionalNestedTestString"
    )

    assert.strictEqual(other.testString, "Cool")
    assert.strictEqual(other.testNumber, 1234)
  })

  it("creates classes with readonly properties", () => {
    const testObject = new addon.TestClass1()
    assert.strictEqual(testObject.readOnlyTestString, "ReadOnlyTest")
    assert.throws(
      () => {
        testObject.readOnlyTestString = "Neat"
        return true
      },
      (err) => {
        assert.strictEqual(err.code, "ESWIFTREADONLYPROPERTY")
        return true
      }
    )
    assert.strictEqual(testObject.readOnlyTestString, "ReadOnlyTest")
  })
})
