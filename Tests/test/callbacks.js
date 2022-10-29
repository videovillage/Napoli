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
})
