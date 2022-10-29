/* eslint-env mocha */

const addon = require('../')

describe('Callbacks:', function () {
  it('runs threadsafe callbacks', function (done) {
    addon.runThreadsafeCallback(function (msg) {
      console.log(msg)
      done()
    })
  })
})
