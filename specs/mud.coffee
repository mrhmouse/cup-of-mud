Vows = require 'vows'
Assert = require 'assert'
Mud = require '../mud.litcoffee'

Vows.describe( 'Mud Template Framework' )
.addBatch
	'Mud renders':
		topic: -> Mud
		'paragraph tags correctly': ->
			check = /\s*<p>\s*Test\s*<\/p>/g

			Assert.ok check.test Mud -> @p 'Test'
		'flat text correctly': ->
			text = 'This is a test!'
			Assert.equal text, Mud -> @text text
		'text HTML-escaped': ->
			Assert.equal '&amp;', Mud -> @text '&'
		'raw text unescaped': ->
			Assert.equal '&', Mud -> @raw '&'
		'numbers properly': ->
			Assert.equal '42', Mud -> @text 42
		'nothing for `undefined`': ->
			Assert.equal '', Mud ->
.export module
