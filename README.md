cup-of-mud
===

A simple template framework written in pure CoffeeScript. Intended to be small and simple, not featureful.

Example
-------

```coffeescript
Mud = require 'cup-of-mud'

Mud -> [
	@raw '<!DOCTYPE html>'
	@html -> [
		@head ->
			@title 'Hello, world!'
		@body ->
			@p '''
				This is an example of the
				Cup of Mud template framework.
			'''
	]
]
```

Output
------

```html
<!DOCTYPE html>
<html>

	<head>

		<title>
			Hello, world!
		</title>

	</head>

	<body>

		<p>
			This is an example of the
			Cup of Mud template framework.
		</p>

	</body>

</html>
```

Available Functions
-------------------

Every valid HTML5 tag should be usable within `Cup of Mud`, with the exception of `DOCTYPE` and comment tags.
Tags that are defined as `void` by the spec will not print any body.
All non-void tags are closed XHTML style, i.e. `<script></script>` instead of `<script><script>`
