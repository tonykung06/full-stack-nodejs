# Some original code is from https://github.com/cloudhead/vows/blob/master/lib/assert/macros.js
assert = require 'assert'
xml2js = require 'xml2js'
xpathLib = require 'xml2js-xpath'

assert.hasTag = (xml, xpath, expected, message) ->
  parser = new xml2js.Parser()
  doc = parser.parseStringSync xml
  element = xpathLib.find(doc, xpath)
  if element[0] is undefined
    throw new Error "XPath '#{xpath}' was not found in the document."
  else if expected and not (expected is element[0])
    assert.fail xml, expected, message || "expected #{xml} to have xpath #{xpath} with content #{expected}", "hasTag", assert.hasTag

assert.hasTagMatch = (xml, xpath, expected, message) ->
  parser = new xml2js.Parser()
  doc = parser.parseStringSync xml
  element = xpathLib.find(doc, xpath)
  if element[0] is undefined
    throw new Error "XPath '#{xpath}' was not found in the document."
  else if expected and not (expected.test(element[0]))
    assert.fail xml, expected, message || "expected #{xml} to have xpath #{xpath} with content #{expected}", "hasTag", assert.hasTag

# Match against a regular expression.
# Automatically converts a String to a RegExp.
assert.match = (actual, expected, message) ->
  if typeOf(expected) is 'string'
    expected = new RegExp(expected)
  if (not expected.test(actual))
    assert.fail(actual, expected, message || "expected #{actual} to match #{expected}", "match", assert.match)
assert.matches = assert.match

assert.notMatch = (actual, expected, message) ->
  if typeOf(expected) is 'string'
    expected = new RegExp(expected)
  if (expected.test(actual))
    assert.fail(actual, expected, message || "expected #{actual} to doesn't match #{expected}", "match", assert.match)


assert.instanceOf = (actual, expected, message) ->
  unless (actual instanceof expected)
    assert.fail(actual, expected, message || "expected #{actual} to be an instance of #{expected}", "instanceof", assert.instanceOf)

assert.typeOf = (actual, expected, message) ->
  assertTypeOf(actual, expected, message, assert.typeOf)

assert.inDelta = (actual, expected, delta, message) ->
  unless Math.abs(actual - expected) <= delta
    assert.fail(actual, expected, message || "expected #{actual} to be within #{delta} of #{expected} but difference was #{Math.abs(actual - expected)}", "inDelta", assert.inDelta)


assertTypeOf = (actual, expected, message, caller) ->
  if (typeOf(actual) isnt expected)
    assert.fail(actual, expected, message || "expected #{actual} to be of type #{expected}", "typeOf", caller)

# A better `typeof`
typeOf = (value) ->
  s = typeof(value)
  types = [Object, Array, String, RegExp, Number, Function, Boolean, Date]
  if (s is 'object' || s is 'function')
    if (value)
      types.forEach (t) ->
        if (value instanceof t)
          s = t.name.toLowerCase()
    else
      s = 'null'
  return s;