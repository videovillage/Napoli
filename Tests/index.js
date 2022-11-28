const assert = require("assert")

module.exports = require("./.build/release/NapoliTests.node")

function dataToUint8Array(data) {
  let uint8array
  if (data instanceof ArrayBuffer || Array.isArray(data)) {
    uint8array = new Uint8Array(data)
  } else if (data instanceof Buffer) {
    // Node.js Buffer
    uint8array = new Uint8Array(data.buffer, data.byteOffset, data.length)
  } else if (ArrayBuffer.isView(data)) {
    // DataView, TypedArray or Node.js Buffer
    uint8array = new Uint8Array(data.buffer, data.byteOffset, data.byteLength)
  } else {
    throw Error(
      "Data is not an ArrayBuffer, TypedArray, DataView or a Node.js Buffer."
    )
  }
  return uint8array
}

function compareData(a, b) {
  a = dataToUint8Array(a)
  b = dataToUint8Array(b)
  if (a.byteLength != b.byteLength) return false
  return a.every((val, i) => val == b[i])
}

function assertDataEqual(actual, expected) {
  assert.ok(compareData(actual, expected))
}

module.exports.assertDataEqual = assertDataEqual
