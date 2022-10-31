/* eslint-env mocha */

const assert = require('assert')
const addon = require('../')

describe('Return Values', () => {
  it('returns strings', () => {
    assert.strictEqual(addon.returnString(), 'a string')
  })

  it('returns numbers', () => {
    assert.strictEqual(addon.returnDouble(), 1337)
  })

  it('returns booleans', () => {
    assert.strictEqual(addon.returnBoolean(), true)
  })

  it('returns dates', () => {
    assert.strictEqual(addon.returnDate().getTime(), 1000)
  })

  it('returns int32', () => {
    assert.strictEqual(addon.returnInt32(), -(2 ** 31))
  })

  it('returns uint32', () => {
    assert.strictEqual(addon.returnUInt32(), (2 ** 32) - 1)
  })

  it('returns int64', () => {
    assert.strictEqual(addon.returnInt64(), Number.MIN_SAFE_INTEGER)
  })

  it('returns null', () => {
    assert.strictEqual(addon.returnNull(), null)
  })

  it('returns undefined', () => {
    assert.strictEqual(addon.returnUndefined(), undefined)
  })
})
