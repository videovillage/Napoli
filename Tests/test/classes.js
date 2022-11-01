/* eslint-env mocha */

const assert = require('assert')
const addon = require('../')

describe('Classes', () => {
  it('creates classes', () => {
    const testObject = new addon.TestClass1()
    assert.strictEqual(testObject.testString, 'Cool')
  })

  it('creates classes with get/set properties', () => {
    const testObject = new addon.TestClass1()
    const other = new addon.TestClass1()

    assert.strictEqual(testObject.testString, 'Cool')
    testObject.testString = 'Changed'
    assert.strictEqual(testObject.testString, 'Changed')

    assert.strictEqual(testObject.testNumber, 1234)
    testObject.testNumber = 4567
    assert.strictEqual(testObject.testNumber, 4567)

    assert.strictEqual(other.testString, 'Cool')
    assert.strictEqual(other.testNumber, 1234)
  })

  it('creates classes with readonly properties', () => {
    const testObject = new addon.TestClass1()
    assert.strictEqual(testObject.readOnlyTestString, 'ReadOnlyTest')
    testObject.readOnlyTestString = 'Neat'
    assert.strictEqual(testObject.readOnlyTestString, 'ReadOnlyTest')
  })
})
