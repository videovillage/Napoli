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
    const result = await addon.returnSuccessfulPromise('cool')
    assert.strictEqual(result, 'cool hello')
  })

  it('returns throwing promise', async function () {
    await assert.rejects(addon.returnThrowingPromise('cool'))
  })
})
