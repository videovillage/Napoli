/* eslint-env mocha */

const addon = require('../')
const assert = require('assert')

describe('Optional Values', () => {
  it('takes optional strings', () => {
    assert.strictEqual(addon.takeOptionalString(null), 'a string')
    assert.strictEqual(addon.takeOptionalString(undefined), 'a string')
    assert.strictEqual(addon.takeOptionalString('a string'), 'a string')
  })

  it('takes optional doubles', () => {
    assert.strictEqual(addon.takeOptionalDouble(null), 1337)
    assert.strictEqual(addon.takeOptionalDouble(undefined), 1337)
    assert.strictEqual(addon.takeOptionalDouble(1337), 1337)
  })

  it('takes optional booleans', () => {
    assert.strictEqual(addon.takeOptionalBoolean(null), true)
    assert.strictEqual(addon.takeOptionalBoolean(undefined), true)
    assert.strictEqual(addon.takeOptionalBoolean(true), true)
  })
})
