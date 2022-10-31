/* eslint-env mocha */

const assert = require('assert')
const addon = require('../')

describe('Callbacks:', function () {
  it('runs threadsafe callbacks', function (done) {
    addon.runThreadsafeCallback(function (msg) {
      assert.strictEqual(msg, 'hello world')
      done()
      return 'message'
    })
  })

  it('returns successful promise', async function () {
    const promise = addon.returnSuccessfulPromise('cool')
    assert.strictEqual(await promise, 'cool hello')
    assert.strictEqual(await promise, 'cool hello')
  })

  it('returns throwing promise', async function () {
    await assert.rejects(addon.returnThrowingPromise('cool'))
  })
})
