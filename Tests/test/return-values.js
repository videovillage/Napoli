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

  it('returns null', () => {
    assert.strictEqual(addon.returnNull(), null)
  })

  it('returns undefined', () => {
    assert.strictEqual(addon.returnUndefined(), undefined)
  })
})
