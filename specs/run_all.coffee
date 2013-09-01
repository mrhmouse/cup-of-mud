Vows = require 'vows'
Path = require 'path'

TESTS = [ 'mud.coffee' ]

require Path.join __dirname, test for test in TESTS

suite.run() for suite in Vows.suites
